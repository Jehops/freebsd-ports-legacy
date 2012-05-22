--- unix/fcitx/mozc_connection.cc.orig	1970-01-01 09:00:00.000000000 +0900
+++ unix/fcitx/mozc_connection.cc	2012-05-22 13:42:56.618829027 +0900
@@ -0,0 +1,174 @@
+// Copyright 2010-2012, Google Inc.
+// All rights reserved.
+//
+// Redistribution and use in source and binary forms, with or without
+// modification, are permitted provided that the following conditions are
+// met:
+//
+//     * Redistributions of source code must retain the above copyright
+// notice, this list of conditions and the following disclaimer.
+//     * Redistributions in binary form must reproduce the above
+// copyright notice, this list of conditions and the following disclaimer
+// in the documentation and/or other materials provided with the
+// distribution.
+//     * Neither the name of Google Inc. nor the names of its
+// contributors may be used to endorse or promote products derived from
+// this software without specific prior written permission.
+//
+// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+#include "unix/fcitx/mozc_connection.h"
+
+#include <string>
+
+#include "base/logging.h"
+#include "base/util.h"
+#include "client/client.h"
+#include "ipc/ipc.h"
+#include "session/commands.pb.h"
+#include "session/ime_switch_util.h"
+#include "unix/fcitx/fcitx_key_translator.h"
+
+namespace mozc {
+namespace fcitx {
+
+MozcConnectionInterface::~MozcConnectionInterface() {
+}
+
+MozcConnection::MozcConnection(
+    mozc::client::ServerLauncherInterface *server_launcher,
+    mozc::IPCClientFactoryInterface *client_factory)
+    : translator_(new KeyTranslator),
+      preedit_method_(mozc::config::Config::ROMAN),
+      client_factory_(client_factory) {
+  VLOG(1) << "MozcConnection is created";
+  mozc::client::ClientInterface *client =
+      mozc::client::ClientFactory::NewClient();
+  client->SetServerLauncher(server_launcher);
+  client->SetIPCClientFactory(client_factory_.get());
+  client_.reset(client);
+
+  mozc::config::Config config;
+  if (client_->EnsureConnection() &&
+      client_->GetConfig(&config) && config.has_preedit_method()) {
+    preedit_method_ = config.preedit_method();
+  }
+  VLOG(1)
+      << "Current preedit method is "
+      << (preedit_method_ == mozc::config::Config::ROMAN ? "Roman" : "Kana");
+}
+
+MozcConnection::~MozcConnection() {
+  client_->SyncData();
+  VLOG(1) << "MozcConnection is destroyed";
+}
+
+bool MozcConnection::TrySendKeyEvent(
+    FcitxKeySym sym, unsigned int state,
+    mozc::commands::CompositionMode composition_mode,
+    mozc::commands::Output *out,
+    string *out_error) const {
+  DCHECK(out);
+  DCHECK(out_error);
+
+  // Call EnsureConnection just in case MozcConnection::MozcConnection() fails
+  // to establish the server connection.
+  if (!client_->EnsureConnection()) {
+    *out_error = "EnsureConnection failed";
+    VLOG(1) << "EnsureConnection failed";
+    return false;
+  }
+
+  mozc::commands::KeyEvent event;
+  translator_->Translate(sym, state, preedit_method_, &event);
+
+  if ((composition_mode == mozc::commands::DIRECT) &&
+      !mozc::config::ImeSwitchUtil::IsDirectModeCommand(event)) {
+    VLOG(1) << "In DIRECT mode. Not consumed.";
+    return false;  // not consumed.
+  }
+
+  VLOG(1) << "TrySendKeyEvent: " << endl << event.DebugString();
+  if (!client_->SendKey(event, out)) {
+    *out_error = "SendKey failed";
+    VLOG(1) << "ERROR";
+    return false;
+  }
+  VLOG(1) << "OK: " << endl << out->DebugString();
+  return true;
+}
+
+bool MozcConnection::TrySendClick(int32 unique_id,
+                                  mozc::commands::Output *out,
+                                  string *out_error) const {
+  DCHECK(out);
+  DCHECK(out_error);
+
+  mozc::commands::SessionCommand command;
+  translator_->TranslateClick(unique_id, &command);
+  return TrySendCommandInternal(command, out, out_error);
+}
+
+bool MozcConnection::TrySendCompositionMode(
+    mozc::commands::CompositionMode mode,
+    mozc::commands::Output *out,
+    string *out_error) const {
+  DCHECK(out);
+  DCHECK(out_error);
+
+  mozc::commands::SessionCommand command;
+  command.set_type(mozc::commands::SessionCommand::SWITCH_INPUT_MODE);
+  command.set_composition_mode(mode);
+  return TrySendCommandInternal(command, out, out_error);
+}
+
+bool MozcConnection::TrySendCommand(
+    mozc::commands::SessionCommand::CommandType type,
+    mozc::commands::Output *out,
+    string *out_error) const {
+  DCHECK(out);
+  DCHECK(out_error);
+
+  mozc::commands::SessionCommand command;
+  command.set_type(type);
+  return TrySendCommandInternal(command, out, out_error);
+}
+
+bool MozcConnection::TrySendCommandInternal(
+    const mozc::commands::SessionCommand& command,
+    mozc::commands::Output *out,
+    string *out_error) const {
+  VLOG(1) << "TrySendCommandInternal: " << endl << command.DebugString();
+  if (!client_->SendCommand(command, out)) {
+    *out_error = "SendCommand failed";
+    VLOG(1) << "ERROR";
+    return false;
+  }
+  VLOG(1) << "OK: " << endl << out->DebugString();
+  return true;
+}
+
+bool MozcConnection::CanSend(FcitxKeySym sym, unsigned int state) const {
+  return translator_->CanConvert(sym, state);
+}
+
+MozcConnection *MozcConnection::CreateMozcConnection() {
+  mozc::client::ServerLauncher *server_launcher
+      = new mozc::client::ServerLauncher;
+
+  return new MozcConnection(server_launcher, new mozc::IPCClientFactory);
+}
+
+}  // namespace fcitx
+
+}  // namespace mozc

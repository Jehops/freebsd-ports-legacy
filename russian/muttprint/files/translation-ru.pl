# This translation file is the Russian translation"
# (c) 2003, Alex Semenyaka <alexs@snark.rinet.ru>

$String{"Benutzung"} = <<EOF;

�������������:   muttprint [�����]... [-f ����]
 
�����:

�������� ��������: ��� ����� ����������� ������������� � ������ ~/.muttprintrc
� /etc/Muttprintrc.

-h, --help
       ��� ���������.

-v, --version
       ���������� ������� ������ Muttprint.

-f [file], --file [file]
       ������ �������� ��������� �� ������� �����, � �� �� ������������ �����.

-p [printername], --printer [printername]
       ������������ ��������� �������.
       "-" ���������� ����������� �����.
       ��� ������ � ���� ����������� TO_FILE:/path/to/file
	   
-i [file], --penguin [file]
       ������ ��������, ������� ����� ���������� �� ������ ��������.

-x, --x-face | -nox, --nox-face
       ��������/��������� ������ X-Faces.

-t [number], --speed [number]
       ����� � ��������, ������� ����� �������� ��� ������ ����� ��������.
		   
-w [number], --wait [number]
       ����� ����� ������� ޣ���� � ��ޣ���� ������� ��� ���������� ������.

-F [fontname], --font [fontname]
       ��������� ������ ��� ������. ��������� ��������:
       Latex, Latex-bright, Times, Utopia, Palatino, Charter � Bookman
	   
-H, --headrule | -noH, --noheadrule
       �������� ��� ��������� ������ ������� ������������
	   
-b, --footrule | -nob, --nofootrule
       �������� ��� ��������� ������ ������ ������������
	   
-S Style | --frontstyle Style
       ������� ����� ������ ��������� �� ������ ��������:
       plain, border (�� ���������), fbox, shadowbox, ovalbox, Ovalbox,
       doublebox, grey, greybox. 
       �� �� ���������� ���������� ���������� � ����������� ������������.

-a [headers], --printed-headers [headers]
       ���� ��������� ������, ������� ������� ��������. ����������� ��������
       � ����������� ������������.
       ������: /Date/_To_From_*Subject*

-P [paperformat], --paper [paperformat]
       ������ ������: "letter" (���) ��� "A4" (������).

-l [language], --lang [language]
       ���� ��������� � ������

-c [charset], --charset [charset]
       ����� ��������: latin1, latin2, latin3, latin4, latin5, latin9,
       auto (�� ������ ������������� "auto" �������� �����������).

-e [string], --date [string]
       original: �������� ���� ��� � ���������
       local:    �������� ��������� ţ � ���������� ������� � ��������� ����

-E [string], --date-format [string]
       ������ ������ ����; ����������� � ������� � strftime(3)

-A [string], --addressformat [string]
       ���������� ������ �������� ������� � ���������. ����������� �������� �
       ��������� man � ����������� ������������.

-n [string], --verbatimnormal [string]
       ������������ ��� �������������� �������� ������. ����������� �������� �
       ��������� man � ����������� ������������.

-V [string], --verbatimsig [string]
       ������������ ��� �������������� �������.

-D, --debug | -noD, --nodebug
       ������ ���������� ���������� � ���������� ���� /tmp/muttprint.log.

-d, --duplex | -nod, --noduplex
       ��������� ��� ��������� ���������� ������.

-g [number], --topmargin [number]
       ������� ����, � �����������.

-G [number], --bottommargin [number]
       ������ ����, � �����������.

-j [number], --leftmargin [number]
       ����� ����, � �����������.

-J [number], --rightmargin [number]
       ������ ����, � �����������.

-2 | -1
       �������� 2 �������� �� ����� �����. ������������� "���������� ������".

-s, --rem_sig | -nos, --norem_sig
       ������� ������� (����̣���� "-- ") ��� ������.

-q, --rem_quote | -noq, --norem_quote
       ������� ����������� ��� ������.

-z [size], --fontsize [size]
       ������ ������: 10pt, 11pt, 12pt (��������� ������ ��� ��������)

-W [number], --wrapmargin [number]
       ���������, ��������� �������� ����� ���� ������.
	   
-r [file], --rcfile [file]
       ������ �������������� ���������������� ����.

EOF

$String{"Lizenz"} = "��� ��������� ���������������� �� ��������
GPL � ����� �������� ������������.
";

$String{"Bugs"} = "�� ������� ��������� <Bernhard.Walle\@gmx.de>.\n";

$String{"FileNotFound"} = "��������� ���� �� ������.\n";

@String{"From", "To", "Subject", "CC", "Date", "Page", "of", "Newsgroups"} =
("From:", "To:", "Subject:", "Carbon Copy:", "Date:", "���.", "��", "Newsgroups:");

$LPack = "english,russian";
$charset = "koi8-r";

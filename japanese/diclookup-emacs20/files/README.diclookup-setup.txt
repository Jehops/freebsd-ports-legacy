		Configuration of diclookup-mule FreeBSD port
							    7.Jun.1998
					   MITA Yoshio <mita@jp.FreeBSD.org>
		  Special thanks to MIHIRA Yoshiro <sanpei@yy.cs.keio.ac.jp>

`Diclookup-mule' is a frontend interface for NDTP (Network Dictionary
Transfer Protocol) server on mule.
One of mule (ja-*mule-2.3 or mule-2.3) is necessary for this program.

1. NDTP server installation.

    An NDTP server must therfore be installed.
    Two programs are known as NDTP server: dserver and ndtpd.

    dserver:  Dictionary server.  NDTP has been a protocol for dserver.
	      It supports EB/EBG/EBXA/EPWING CDROM dictionaries.
	      FreeBSD port is ready for installation: ja-dserver-2.2.2
	      Dserver packages includes `dictionary file compression tool'

    ndtpd:    Dserver-compatible Network Dictionary server.  
	      It also supports EB/EBG/EBXA/EPWING CDROM dictionaries.
    Also refer documents to each packages for setup of server.

1. Add startup code to site-start.el
    Typing
	% /usr/local/lib/dserver/setup-diclookup.sh
    displays you `ja-diclookup setup dialog':
     ------------------------ja-diclookup setup --------------------------
     |                                                                   |
     | You have to install appropreate startup code for diclookup-mule.  |
     | This setup script automatically it to:                            |
     | /usr/local/share/mule/19.34/site-lisp/site-start.el.              |
     |                                                                   |
     | Are you sure?                                                     |
     |-------------------------------------------------------------------|
     |                       [ Yes ]         No                          |
     |-------------------------------------------------------------------|
	By answering [ Yes ], startup code is automatically added to
	/usr/local/share/mule/19.34/site-lisp/site-start.el
	(Deinstallation is possible by deinstall-diclookup.sh)

2. Usage.
    Typing `M-x diclookup-mule' launches a new window for dictionary looking up.
	f`word for looking up'[Enter] : Lookup a word
	C`dictionary name'[Enter]     : Change dictionary (TAB complition OK)
	o			      : Switch to other window
	n,p,[ENTER]		      : Move cursor in window.
	Q		              : Quit and delete window.
	q			      : Suspend


                 Dserver FreeBSD port���åȥ��åפˤĤ��ơ�

                                                             3.Nov.1996
						Revised	    20.Dec.1996
						Revised	    31.Jan.1998
                                         ���ĵ�Ϻ <mita@jp.FreeBSD.org>


	�ܼ�
	0. diclookup-mule ���Ѥ�����.
	I. ��ư�ν���.
	   I.1. setup.sh �ζ���Ū�ʺ��
	II. ���(uninstall)

diclookup-mule ��, mule �ξ��, �ŻҼ���������褦�ˤ��뤿���
�ץ����Ǥ�. ����ñ�Τ��ŻҼ��񤬰�����ΤǤϤʤ�, ���񥵡��Ф�
���� CDROM (��mule)�Ȥ����������󥹥ȡ��뤷��, �Ϥ���ƻȤ���褦��
�ʤ�ޤ�.  �ȤϤ���, �����񤷤�����ޤ���Τ�, ��¿���.

0. diclookup-mule ���Ѥ�����.
    NDTP (Network ����ž���ץ�ȥ���)�����Ф򥤥󥹥ȡ��뤷��, ư���褦��
    ���Ƥ������Ȥ�ɬ�ܤǤ�.
    NDTP �����ФȤ��Ƥ�, Ϸ�ޤ� dserver ��, SRA �γ޸����󤬳�ȯ�ʤ��äƤ��� 
    ndtpd �ʤɤ��Τ��Ƥ��ޤ�. 
    dserver ��, ja-dserver-2.2.2 �Ȥ����ѥå������ˤʤäƤ��ޤ�.
    ndtp ����� FreeBSD ports colleciton �˼����ޤ�뤳�ȤǤ��礦.
    
    dserver �ޤ���, ndtp �������, ���줾��Υѥå���������°��
    ʸ��򻲾Ȥ��Ƥ�������.
    
I. ��ư�ν���.

    ~/.emacs �⤷���� ${PREFIX}/share/mule/19.34/site-lisp/site-start.el �ʤɤ�,
    �������ե������, diclookup-mule ��ư�Τ���Υ���ȥ���ɲä��ޤ�.
    [${PREFIX}/lib/dserver/setup-diclookup.sh] ��ư�����, ��ưŪ��
   �����site-start.el ���ɲä��Ƥ���ޤ���

  �� ${PREFIX}
     ������ ${PREFIX} �Ȥ� ports �򥳥�ѥ�����δĶ��ѿ� PREFIX ��
     �����ޤ�. packages �Ǥ�, [/usr/local] �Ȥʤ�ޤ�.  �嵭�ξ��,
     [/usr/local/lib/dserver/setup-diclookup.sh] ��Ŭ���ɤߤ����Ƥ�������. 

II. site-start.el �κ��Խ�.

   setup-diclookup.sh ��ư�����, ��ưŪ��������ɲä��Ƥ����ΤǤ���,
   ����������������Ȥ�������ޤ�.
   ${PREFIX}/share/mule/19.34/site-lisp/site-start.el �μ��ιԤǤ�.

--------
(setq od-dictfile-list '("od-chujiten" "od-kojien" "od-readers" "od-crown")) ; diclookup-mule
--------

   ���ιԤǤ�, ���Ѥ��뼭�� CDROM ����������ޤ�Ƥ��볰����, mule ��ɽ��
   �����뤿���ʸ�����Ȥ߹�碌�Ȥ��б�ɽ (�����¸�ե�����)���ɤ߹���
   ���Ƥ��ޤ�.  �����Ǥ�,

    od-chujiten       EBXA �� ����ҿ����¡��±��漭ŵ5��3��
    od-kojien         EBXA �� ���Ƚ�Ź������
    od-readers        EBXA �� ����ҥ꡼���������¼�ŵ
    od-crown          EBXA �� ����Ʋ���饦��ʩ�¡����¼�ŵ

   �Ȥ���, �仰�Ĥ����äƤ��� 8cm CDROM ����μ����¸�ե�������ɤ߹���
   ���Ƥ��ޤ�.

   diclookup-mule-2.3.3 �ˤ�¾�ˤ�, ���Τ褦�ʼ����¸�ե����뤬·�ä�
   ���ޤ��Τ�, Ŭ���ɲú�����ޤ�.

    od-chujiten64     EBXA �� ����ҿ����¡��±��漭ŵ6��4��
    od-chujiten64-epw EPWING �� ����ҿ����¡��±��漭ŵ6��4��
    od-oxford         Oxford ���󥵥����ѱѼ�ŵ, �������饹
    od-italian        ���������������� ���奤���ꥢ��ɽ����ŵ

   �ä�, EPWING �� ����ҿ����¡��±��漭ŵ6��4�� ��, �ѥ��ե��å�
   �ϥ��ƥå�http://www.pht.co.jp/ ���󤫤�ФƤ���, 
   FreeBSD Pro 2.2.6J �˥Х�ɥ뤵��Ƥ���ʤ�, 
   ɸ��Ū������Ƥ��뼭��ʤΤ�, ���μ���򤪻��������������Ƥ����
   �פ��ޤ��Τ���դ�ɬ�פǤ�.
   (��­�ʤ���, xanim �򥤥󥹥ȡ��뤷��, EPWING �Ǥο������漭ŵ��
    �Ȥ���, �����ǡ�����ʹ�����Ȥ��Ǥ��ޤ�. �����ȯ����Фä���.)

III. ���(uninstall)

    ����ϡ����󥹥ȡ���εդ�Ԥ��Ф褤�櫓�Ǥ�������ưŪ�˺����
  �Ԥ�����Υ����륹����ץȡ�[${PREFIX}/lib/dserver/deinstall.sh] ��
  �Ѱդ��Ƥ����ޤ�����

    ���θ�ǡ�pkg_delete��Ԥ���OK�ΤϤ��Ǥ���

���䡤��ʿ�����ʤɸ�¤��ޤ�����mita@jp.FreeBSD.org�ˤɤ�����

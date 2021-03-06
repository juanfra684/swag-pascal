(*
  Category: SWAG Title: DOS & ENVIRONMENT ROUTINES
  Original name: 0047.PAS
  Description: Loading Overlays in XMS
  Author: REINHARDT MUELLER
  Date: 02-03-94  16:17
*)


{
With this unit, it doesn't matter if the overlay is separate,
or tacked onto the end of the .EXE file -- the program will
run either way.

As written, this unit also uses OVERXMS, a PD unit written
Wilbert Van Leijen.  Floating around the BBS's as OVERXMS.ZIP
You may delete the references to XMS.
The XMS stuff is in there because the program I copied this
code from will run on a 486 and just about all of the college
machines have XMS memory -- few if any have EMS. }

{$A-,B+,D-,F+,I-,L-,N-,O-,Q+,R-,S-,V-}

UNIT RVOVRLAY;

{ This unit starts the overlay manager }

INTERFACE
Const
  ovrNoXMSDriver = -7;   { No XMS driver installed }
  ovrNoXMSMemory = -8;   { Insufficient XMS memory available }


IMPLEMENTATION

USES DOS, OVERLAY;

{ OVERXMS - Loads overlays in XMS.
  Assembly-language portion written by Wilbert van Leijen }
Procedure OvrInitXMS; External;
{$L OVERXMS.OBJ }

Function Exist(Filename:string):boolean;
{returns true if file exists}

var Inf: SearchRec;

begin
  FindFirst(Filename,AnyFile,Inf);
  Exist := (DOSError = 0);
end;  {Func Exist}


Procedure S_Write (Msg : string);

BEGIN  {Dirty trick to generate less code}
  Write (msg);
END;


Procedure WriteOvrErrMsg;

VAR
  garbage:char;

BEGIN
  WRITE ('Overlay error: ',OvrResult,'  ');
  IF (OvrResult = ovrOk) THEN S_WRITE ('Ok - No error');
  IF (OvrResult = ovrError) THEN S_WRITE ('Missing Overlay error');
  IF (OvrResult = ovrNotFound) THEN S_WRITE ('Overlay file not found');
  IF (OvrResult = ovrNoMemory) THEN S_WRITE ('No Memory for overlays');
  IF (OvrResult = ovrIOError) THEN S_WRITE ('Overlay IO Error');
  IF (OvrResult = ovrNoEMSDriver) THEN S_WRITE ('No EMS Driver');
  IF (OvrResult = ovrNoEMSMemory) THEN S_WRITE ('No EMS Memory');
  IF (OvrResult = ovrNoXMSDriver) THEN S_WRITE ('No XMS Driver');
  IF (OvrResult = ovrNoXMSMemory) THEN S_WRITE ('No XMS Memory');
  S_WRITE (^M^J);
  read (garbage);
  If OvrResult <> OvrOK THEN HALT (98);
END;  { Procedure WriteOvrErrMsg }


BEGIN      { main }

  IF (lo(DosVersion) < 3) THEN
    BEGIN
      WriteLn ('You are using DOS version ',Lo(DosVersion),
               '.',Hi(DosVersion));
      Writeln ('Mulesoft Revenge requires DOS v3.0 or greater.');
      HALT (99);
    END;

  { Start overlay manager and assume that overlay is in
    the .EXE file.  If not found in .EXE file, assume the
    overlay file is separate from the .EXE file. }

  OVRINIT (paramstr(0));

  If (OvrResult = ovrError) THEN  { Overlay not at end of .EXE file }
    OVRINIT (copy(paramstr(0), 1, Length(paramstr(0))-3) + 'OVR');
  IF (OvrResult <> OvrOk) THEN
      WriteOvrErrMsg
  ELSE     { Try to load the overlay into XMS memory }
    BEGIN
      OvrInitXms;
      IF (OvrResult <> OvrOk) THEN
        OvrInitEms;
    END;
END.

{------------------------- snip, snip ----------------------------}

   Here is the .OBJ file that goes with this file ...
   you will need XX3402 o decode this output:

   Cut this out to a file named OVERXMS.XX.
   Execute XX3402 d OVERXMS.XX

   You will then get the file OVERXMS.OBJ to compile this unit

*XX3402-000913-020294--72--85-48736-----OVERXMS.OBJ--1-OF--1
U+o+0qxqNL7sPLAiEJBBFMUU++++53FpQa7j623nQqJhMalZQW+UJaJmQqZjPW+n9X8NW-A+
ECafC26Q0qxqNL7sPLAiEJBBnMU1+21dH7M0++-cW+A+E84IZUM+-2F-J234a+Q+G-c++U2-
ytM4++F1HoF3FNU5+0Wi+EA-+MKAJ++7I373FYZMIoJ5++V3K2ZII37DEk+7HpNGIYJHJIlI
++hDJZ71HoF3H2ZHJ++AHpNGF2xHG23CF2l3++dDJZ76FI3EHp75++dDJZ7GFI32EZJ4+0OE
2E+++UdDJZ77HYZIK2pHCE2+xcU2+20W+N4UgU20++093VU+h+fz5U++l+M2+8A++6k4+U19
Aw+nocgS+++15U++UwAEXgAa+kM6+6DG+0O95Us+0xhptfg+-DTnYY8o0TwS+++9k5E2WFMM
+ABJWymCFUMacEU+ckU+Aw0X0U0V4+0X1++acFM+cks+7e2M+8AE+1D+cl6+clE+7e2E+8AK
+9E9jUU+zls+++j+R+F6ukGEiDnzLQc0+0O93UU+xw6-+5E4EWPz-UU+WFM6+1D+ckc+ckk+
cks+cE++cl++cFU+cl6+WHsI+6YS3U0o0vs6+DwS+++1ycDH++j+R+9skzb1JMjgcE++AwY1
-U++-F++Xg-EEGOV1U+9k5LhAxgnzkRFcE++7eAE+0O75VU+7cYy3U-HJkM4zls+++RTKmP5
-V++++1rq566u4jzQUBNsgy9tJr1Aw+v-U++REF6uqOEi+-1nGwwU5E4iDbzupSEi--1nGy7
5U++X+M0+CWmzbI4iDXzunyEu5PzQl093VU+h+fz5U++iDnzumeEWls++9EynG55-U++HU0A
1U6+l+M++8A2+6k4-U15-U++++0A1U6+Aw0X++19RdnW+AE0J+5203E-l+lI+QED-U20l-A4
+E925+M--AEU-U2-l2BI+QF9J+52KJE-l3tI+QFVJ+52N3E-l4hI+QFmJ+52RpE-l5dI+QG-
J+52VZE-l6dI+QGiJ+52gpE-l9NI+QGtJ+52j+M--gGzJ+52kZE-lAJI+QH7J+52nJE-lB7I
+QHKJ+52uEM--AHj-U2-lEQ4+EP35EM--wIx-U23lJhI+QJTJ+53QpE-lLZI+QK1-U23lMg4
+ET3XJE0lN24+ET3ZEM-+gKMJ+53b3E-lO+4+E93cZE0lOM4+E93ekM-+z88+U++R+++
***** END OF BLOCK 1 *****

{---------------------         OVERXMS.ASM   --------------------- }
{                          NEED MASM,TASM to compile               }

TITLE Turbo Pascal XMS support for loading overlays - By Wilbert van Leijen
PAGE 65, 132
LOCALS @@

Data       SEGMENT Word Public
           ASSUME  DS:Data

;  XMS block move record

XmsMoveType STRUC
           BlkSize     DD    ?
           SrcHandle   DW    ?
           SrcOffset   DD    ?
           DestHandle  DW    ?
           DestOffset  DD    ?
XmsMoveType ENDS

;  TP overlay manager record

OvrHeader  STRUC
           ReturnAddr  DD    ?         ; Virtual return address
           FileOfs     DD    ?         ; Offset into overlay file
           CodeSize    DW    ?         ; Size of overlay
           FixupSize   DW    ?         ; Size of fixup table
           EntryPts    DW    ?         ; Number of procedures
           CodeListNext DW   ?         ; Segment of next overlay
           LoadSeg     DW    ?         ; Start segment in memory
           Reprieved   DW    ?         ; Loaded in memory flag
           LoadListNext DW   ?         ; Segment of next in load list
           XmsOffset   DD    ?         ; Offset into allocated XMS block
           UserData    DW    3 DUP(?)
OvrHeader  ENDS

XmsDriver  DD      ?                   ; Entry point of XMS driver
ExitSave   DD      ?                   ; Pointer to previous exit proc
XmsMove    XmsMoveType <>
OvrXmsHandle DW    ?                   ; Returned by XMS driver

           Extrn   PrefixSeg : Word
           Extrn   ExitProc : DWord
           Extrn   OvrResult : Word
           Extrn   OvrCodeList : Word
           Extrn   OvrDosHandle : Word
           Extrn   OvrHeapOrg : Word
           Extrn   OvrReadBuf : DWord
Data       ENDS

Code       SEGMENT Byte Public
           ASSUME  CS:Code
           Public  OvrInitXMS

ovrIOError     EQU     -4
ovrNoXMSDriver EQU     -7
ovrNoXMSMemory EQU     -8

OvrXmsExit PROC

; Release handle and XMS memory

        MOV    DX, [OvrXmsHandle]
        MOV    AH, 10
        CALL   [XmsDriver]

; Restore pointer to previous exit procedure

        LES    AX, [ExitSave]
        MOV    Word Ptr [ExitProc], AX
        MOV    Word Ptr [ExitProc+2], ES
        RETF
OvrXmsExit ENDP

AllocateXms PROC

;  Determine the size of the XMS block to allocate:
;  Walk the CodeListNext chain
;  Store the total codesize in DX:AX

        XOR    AX, AX
        XOR    DX, DX
        MOV    BX, [OvrCodeList]
@@1:    ADD    BX, [PrefixSeg]
        ADD    BX, 10h
        MOV    ES, BX
        ADD    AX, ES:[OvrHeader.CodeSize]
        ADC    DX, 0
        MOV    BX, ES:[OvrHeader.CodeListNext]
        OR     BX, BX
        JNZ    @@1

;  Obtain number of kilobytes to allocate

        MOV    BX, 1024
        DIV    BX
        XCHG   DX, AX
        INC    DX

;  Allocate the block

        MOV    AH, 9
        CALL   [XmsDriver]
        OR     AX, AX
        JZ     @@2
        MOV    [OvrXmsHandle], DX
@@2:    RETN
AllocateXms ENDP

;  Function XmsReadFunc(OvrSeg : Word) : Integer; Far;

XmsReadFunc PROC

;  Swap the code from XMS to the heap

        PUSH   BP
        MOV    BP, SP
        MOV    ES, [BP+6]
        MOV    AX, ES:[OvrHeader.CodeSize]
        MOV    Word Ptr [XmsMove.BlkSize], AX
        XOR    AX, AX
        MOV    Word Ptr [XmsMove.BlkSize+2], AX
        MOV    AX, [OvrXmsHandle]
        MOV    [XmsMove.SrcHandle], AX
        MOV    AX, Word Ptr ES:[OvrHeader.XmsOffset]
        MOV    Word Ptr [XmsMove.SrcOffset], AX
        MOV    AX, Word Ptr ES:[OvrHeader.XmsOffset+2]
        MOV    Word Ptr [XmsMove.SrcOffset+2], AX
        XOR    AX, AX
        MOV    [XmsMove.DestHandle], AX
        MOV    Word Ptr [XmsMove.DestOffset], AX
        MOV    AX, ES:[OvrHeader.LoadSeg]
        MOV    Word Ptr [XmsMove.DestOffset+2], AX
        MOV    AH, 11
        LEA    SI, XmsMove
        CALL   [XmsDriver]
        OR     AX, AX
        JZ     @@1
        DEC    AX
        JMP    @@2

@@1:    MOV    AX, ovrIOError
@@2:    POP    BP
        RETF   2
XmsReadFunc ENDP

;  Copy an overlaid unit from the heap to XMS
;  If successful, carry flag is cleared
;  In/Out:
;    BX:DI = offset into XMS memory block

CopyUnitToXms PROC

;  XMS requires that an even number of bytes is moved

        MOV    DX, ES:[OvrHeader.CodeSize]
        TEST   DX, 1
        JZ     @@1
        INC    DX
        INC    ES:[OvrHeader.CodeSize]

;  Get the fields of the XMS block move structure

@@1:    MOV    Word Ptr [XmsMove.BlkSize], DX
        XOR    AX, AX
        MOV    Word Ptr [XmsMove.BlkSize+2], AX
        MOV    [XmsMove.SrcHandle], AX
        MOV    Word Ptr [XmsMove.SrcOffset], AX
        MOV    AX, [OvrHeapOrg]
        MOV    Word Ptr [XmsMove.SrcOffset+2], AX
        MOV    AX, [OvrXmsHandle]
        MOV    [XmsMove.DestHandle], AX
        MOV    Word Ptr [XmsMove.DestOffset], DI
        MOV    Word Ptr [XmsMove.DestOffset+2], BX
        MOV    AH, 11
        LEA    SI, XmsMove
        CALL   [XmsDriver]

;  Bump code size

        ADD    DI, DX
        ADC    BX, 0

;  Check return code from XMS driver

        OR     AX, AX
        JZ     @@2
        CLC
        RETN

@@2:    STC
        RETN
CopyUnitToXms ENDP

OvrXmsLoad PROC
        PUSH   BP
        MOV    BP, SP

;  Walk the CodeList chain
;  First segment is PrefixSeg+10h+OvrCodeList
;  Push each element of overlaid unit list on the stack
;  Keep the size of the linked list in CX

        MOV    AX, [OvrCodeList]
        XOR    CX, CX
@@1:    ADD    AX, [PrefixSeg]
        ADD    AX, 10h
        MOV    ES, AX
        PUSH   AX
        INC    CX
        MOV    AX, ES:[OvrHeader.CodeListNext]
        OR     AX, AX
        JNZ    @@1

;  Loop:
;    Pop each element of the overlaid unit list from the stack

        XOR    BX, BX
        XOR    DI, DI
@@2:    POP    ES
        PUSH   CX
        MOV    AX, [OvrHeapOrg]
        MOV    ES:[OvrHeader.LoadSeg], AX
        MOV    Word Ptr ES:[OvrHeader.XmsOffset+2], BX
        MOV    Word Ptr ES:[OvrHeader.XmsOffset], DI

;  Load overlay from disk

        PUSH   BX
        PUSH   DI
        PUSH   ES
        PUSH   ES
        CALL   [OvrReadBuf]
        POP    ES
        POP    DI
        POP    BX

;  Flag unit as 'unloaded'; check return code

        MOV    ES:[OvrHeader.LoadSeg], 0
        NEG    AX
        JC     @@3

        CALL   CopyUnitToXms
        JC     @@3

        POP    CX
        LOOP   @@2

@@3:    MOV    SP, BP
        POP    BP
        RETN
OvrXMSLoad ENDP

OvrInitXMS PROC

;  Make sure the file's been opened

        XOR    AX, AX
        CMP    AX, [OvrDOSHandle]
        JNE    @@1
        DEC    AX                      ; ovrError
        JMP    @@5

;  Check presence of XMS driver

@@1:    MOV    AX, 4300h
        INT    2Fh
        CMP    AL, 80h
        JE     @@2
        MOV    AX, ovrNoXmsDriver
        JMP    @@5

;  Get XMS driver's entry point

@@2:    MOV    AX, 4310h
        INT    2Fh
        MOV    Word Ptr [XmsDriver], BX
        MOV    Word Ptr [XmsDriver+2], ES
        CALL   AllocateXms
        JNZ    @@3
        MOV    AX, ovrNoXMSMemory
        JMP    @@5

;  Load the overlay into XMS

@@3:    CALL   OvrXmsLoad
        JNC    @@4

;  An error occurred.  Release handle and XMS memory

        MOV    DX, [OvrXmsHandle]
        MOV    AH, 10
        CALL   [XmsDriver]
        MOV    AX, ovrIOError
        JMP    @@5

;  Close file

@@4:    MOV    BX, [OvrDOSHandle]
        MOV    AH, 3Eh
        INT    21h

;  OvrReadBuf := XmsReadFunc

        MOV    Word Ptr [OvrReadBuf], Offset XmsReadFunc
        MOV    Word Ptr [OvrReadBuf+2], CS

;  ExitSave := ExitProc
;  ExitProc := OvrXmsExit

        LES    AX, [ExitProc]
        MOV    Word Ptr [ExitSave], AX
        MOV    Word Ptr [ExitSave+2], ES
        MOV    Word Ptr [ExitProc], Offset OvrXmsExit
        MOV    Word Ptr [ExitProc+2], CS

;  Return result of initialisation

        XOR    AX, AX
@@5:    MOV    [OvrResult], AX
        RETF
OvrInitXMS ENDP

Code       ENDS
           END


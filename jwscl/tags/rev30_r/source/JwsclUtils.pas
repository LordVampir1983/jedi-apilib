{
@abstract(This unit hosts utilty functions.)
@author(Christian Wimmer)
@created(03/23/2007)
@lastmod(09/10/2007)

Project JEDI Windows Security Code Library (JWSCL)

The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy of the
License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
ANY KIND, either express or implied. See the License for the specific language governing rights
and limitations under the License.

The Original Code is JwsclUtils.pas.

The Initial Developer of the Original Code is Christian Wimmer.
Portions created by Christian Wimmer are Copyright (C) Christian Wimmer. All rights reserved.

Description:
This unit hosts utility functions.
}
unit JwsclUtils;
{$I Jwscl.inc}
// Last modified: $Date: 2007-09-10 10:00:00 +0100 $


//Check for FastMM4
{$IFDEF FASTMM4}
  //and also activate debug mode (leak detection for Local-/GlobalAlloc)
  {$DEFINE FullDebugMode}
{$ENDIF FASTMM4}
{.$UNDEF FullDebugMode}

//check for Eurekalog
{$IFDEF EUREKALOG}
  {$DEFINE FullDebugMode}
{to see if this memory manager catches Local/Global leaks}  
  {.$UNDEF FASTMM4}
  {.$UNDEF MEMCHECK}
  {.$UNDEF FullDebugMode}
{$ENDIF EUREKALOG}

interface

uses
  jwaWindows,
{$IFDEF JCL}
  JclWideFormat,
  JclWideStrings,
{$ENDIF}
  JwsclExceptions,
  JwsclResource,
  JwsclTypes,
  JwsclStrings;

procedure JwGlobalFreeAndNil(var hMem: HGLOBAL);

{@Name creates a managed memory handle by LocalAlloc.
Some memory leak managers do not recognize leaks created by
LocalAlloc and GlobalAlloc. Thus we create for them a GetMem
memory block.
Replace each call to LocalAlloc/GlobalAlloc with JwLocalAllocMem/JwGlobalAllocMem
and their counter parts JwLocalFreeMem/JwGlobalFreeMem.
If a counter part is not called and the program halts the memory manager
will (hopefully) show the stack trace to the GetMemPointer created by
JwLocalAllocMem/JwGlobalAllocMem.

Warning: Do not call JwLocalAllocMem/JwGlobalAllocMem for API functions
that will give the handle free for themselves. GetMemPointer will remain
whatsoever. Instead use LocalAlloc/GlobalAlloc.
This behavior is rare but the API documentation will (mostly) say it.
Refer to MSDN documentation for more information.}
function JwLocalAllocMem(uFlags: UINT; uBytes: SIZE_T): HLOCAL;

{@Name frees a managed LocalAlloc handle created by JwLocalAllocMem.
The given handle will be set to 0.
Refer to MSDN documentation for more information.
@raises EInvalidPointer if the given handle was not created by JwLocalAllocMem.}
function JwLocalFreeMem(var hMem: HLOCAL): HLOCAL;

{@Name creates a managed memory handle by LocalAlloc.
Some memory leak managers do not recognize leaks created by
LocalAlloc and GlobalAlloc. Thus we create for them a GetMem
memory block.
Replace each call to LocalAlloc/GlobalAlloc with JwLocalAllocMem/JwGlobalAllocMem
and their counter parts JwLocalFreeMem/JwGlobalFreeMem.
If a counter part is not called and the program halts the memory manager
will (hopefully) show the stack trace to the GetMemPointer created by
JwLocalAllocMem/JwGlobalAllocMem.

Warning: Do not call JwLocalAllocMem/JwGlobalAllocMem for API functions
that will give the handle free for themselves. GetMemPointer will remain
whatsoever. Instead use LocalAlloc/GlobalAlloc.
This behavior is rare but the API documentation will (mostly) say it.
Refer to MSDN documentation for more information.}
function JwGlobalAllocMem(uFlags: UINT; uBytes: SIZE_T): HGLOBAL;

{@Name frees a managed GlobalAlloc handle created by JwGlobalAllocMem.
The given handle will be set to 0.
Refer to MSDN documentation for more information.
@raises EInvalidPointer if the given handle was not created by JwGlobalAllocMem.}
function JwGlobalFreeMem(var hMem: HGLOBAL): HGLOBAL;





{@Name loads the resource strings of a TJwRightsMapping record array
defined in JwsclTypes.pas.
To convert a rights mapping record array define a start resource string
index, say 4000. This is the starting point of the resource strings, but
it does not define a string. It simply contains a number that defines the count
of array elements, say 4.
So the record array must look like this :
@longcode(#
  MyMapping: array[1..4] of TJwRightsMapping =
    (
    (Right: STANDARD_RIGHTS_ALL; Name: 'STANDARD_RIGHTS_ALL';
    Flags: 0; StringId : 5008),
    (Right: STANDARD_RIGHTS_READ; Name: 'STANDARD_RIGHTS_READ';
    Flags: 0),
    (Right: STANDARD_RIGHTS_WRITE; Name: 'STANDARD_RIGHTS_WRITE';
    Flags: 0),
    (Right: STANDARD_RIGHTS_EXECUTE; Name: 'STANDARD_RIGHTS_EXECUTE';
    Flags: 0));
#)
Each element is linked to the resource string. e.g.
 MyMapping[1].Name is read from string resource with index [4001]
 MyMapping[2].Name is read from string resource with index [4002] and so on.
So the last index of the array (here 4) is resource index [4004].

There is the possibility to use exceptional indexes. To do so set StringId
member of the TJwRightsMapping to an index which starts at "StartStringId".
The positive number will be increased by the parameter StartStringId to
get the resource string index.
E.g. set StringId to 20 to load the resource string from index [4020] (=
<StartStringId> + 20)
It is also possible to use absolute values - like 4020. To use them
simply negate the StringId. e.g. StringID: "-4020" will load index [4020].
It is discouraged to use absolute values because they do not depend on the
parameter StartStringId. Changing this value and the resource strings
will lead to EJwsclResourceNotFound exception.

@param([in,out] MappingRecord receives an array of TJwRightsMapping which
  string member Name is replaced by the resource string.)

@param(StartStringId defines the starting position of the index counting.
 It must be an absolute resource string index, which context contains a number
 that defines the count of array elements.)

@param(PrimaryLanguageId defines the primary language id.
use PRIMARYLANGID(GetUserDefaultUILanguage), SUBLANGID(GetUserDefaultUILanguage)
to get user language.)

@param(SubLanguageId defines the sub language id.)

@param(UseDefaultOnError defines whether EJwsclResourceNotFound is thrown if a
resource index is invalid (could not be found in resource) (false) or not (true).
If UseDefaultOnError is true the function does the following.
@orderedlist(
@item(Try to load resource string at index given by member StringId)
@item(if fails : try to load resource string ignoring member StringId)
@item(if fails : leave the text member Name to default value)
))

@param(ModuleInstance defines where the resource strings can be found. It is simply
put through to LoadString function. It can be an instance of a dll file which
contains localized versions of the strings.)

@raises(EJwsclResourceInitFailed is raised if the given value in parameter
StartStringId could not be found in the string resource)

@raises(EJwsclResourceUnequalCount is raised if the count of the members of
the given array (MappingRecord) is not equal to the number given in the resource
string at index StartStringId.)

@raises(EJwsclResourceNotFound is raised if UseDefaultOnError is false and
a given resource index of a member of the array of TJwRightsMapping could not
be found)}
procedure LocalizeMapping(var MappingRecord : array of TJwRightsMapping;
  const StartStringId : Cardinal;
  const PrimaryLanguageId, SubLanguageId : Word;
  const UseDefaultOnError : Boolean = true;
  ModuleInstance : HINST = 0
  );



implementation
uses Classes, SysUtils, JwsclToken, JwsclKnownSid, JwsclDescriptor, JwsclAcl,
     JwsclSecureObjects, JwsclMapping;






procedure LocalizeMapping(var MappingRecord : array of TJwRightsMapping;
  const StartStringId : Cardinal;
  const PrimaryLanguageId, SubLanguageId : Word;
  const UseDefaultOnError : Boolean = true;
  ModuleInstance : HINST = 0
  );
var ArrayHi,ArrayLo : Cardinal;
    LHi : Cardinal;
    i,
    Id : Integer;
    bSuccess : Boolean;
    S : TJwString;

  function GetNumber(S : TJwString) : Cardinal;
  var i : Integer;
  begin
    for i := 1 to Length(S) do
    begin
      //if not ((S[i] >= '0') and (S[i] <= '9')) then
      if not (S[i] in [TJwChar('0')..TJwChar('9')]) then
      begin
        SetLength(S, i-1);
        break;
      end;
    end;
    result := StrToIntDef(S,0);
  end;
begin
  ArrayHi := high(MappingRecord);
  ArrayLo := low(MappingRecord);

  if ModuleInstance = 0 then
    ModuleInstance := HInstance;


  try
    S := LoadLocalizedString(StartStringId, PrimaryLanguageId, SubLanguageId, ModuleInstance);
  except
     on E : EJwsclOSError do
       raise EJwsclResourceInitFailed.CreateFmtEx(
               RsResourceInitFailed,
               'LocalizeMapping', '', RsUNConstants, 0, true,
                [StartStringID]);
  end;

  {Load last string number and compare it to the highest one
   of the given array. If unequal we have a problem.}
  LHi := GetNumber(S);
  if (LHi < ArrayHi+1) then
    raise EJwsclResourceUnequalCount.CreateFmtEx(
            RsResourceUnequalCount,
            'LocalizeMapping', '', RsUNConstants, 0, false, [LHi,StartStringID,ArrayHi]);


  for i := ArrayLo to ArrayHi do
  begin
    bSuccess := true;
    
    if MappingRecord[i].StringId > 0 then
    begin
      Id := MappingRecord[i].StringId;
      Inc(Id, StartStringID);
    end
    else
    if MappingRecord[i].StringId < 0 then
      Id := (-MappingRecord[i].StringId)
    else
    begin
      Id := i;
      Inc(Id);
      Inc(Id, StartStringID);
    end;


    try
      S := LoadLocalizedString(Id, PrimaryLanguageId, SubLanguageId, ModuleInstance);
    except
      on E : EJwsclOSError do
      begin
        if UseDefaultOnError then
        begin
          Id := i;
          Inc(Id);
          Inc(Id, StartStringID);
        end;

        try
          S := LoadLocalizedString(Id, PrimaryLanguageId, SubLanguageId, ModuleInstance);
        except
          on E : EJwsclOSError do
          begin
            if UseDefaultOnError then
              bSuccess := false
            else
              raise EJwsclResourceNotFound.CreateFmtEx(
                RsResourceNotFound,
                'LocalizeMapping', '', RsUNConstants, 0, true, [Id]);
          end;
        end; //try except
      end;
    end; //try except

    if bSuccess then
      MappingRecord[i].Name := S;
  end;
end;


{$IFDEF FullDebugMode}
type
     PMemTuple = ^TMemTuple;
     TMemTuple = record
       GetMemPointer : Pointer;
       case MemType : Boolean of
         true : (LocalData : HLOCAL);              
         false: (GlobalData : HGLOBAL);
      end;
var InternalMemArray : TList {=nil};
{$ENDIF}


function JwLocalAllocMem(uFlags: UINT; uBytes: SIZE_T): HLOCAL;
{$IFDEF FullDebugMode}
var MemTuple : PMemTuple;
{$ENDIF FullDebugMode}
begin
  result := LocalAlloc(uFlags,uBytes);
{$IFDEF FullDebugMode}
  if result <> 0 then
  begin
    New(MemTuple);
    GetMem(MemTuple.GetMemPointer,uBytes);
    MemTuple.MemType := true;
    MemTuple.LocalData := result;
    InternalMemArray.Add(MemTuple);
  end;
{$ENDIF}
end;

function JwLocalFreeMem(var hMem: HLOCAL): HLOCAL;
{$IFDEF FullDebugMode}
  function Find : Integer;
  var i : Integer;
  begin
    result := -1;
    for I := 0 to InternalMemArray.Count - 1 do
    begin
      if PMemTuple(InternalMemArray[i]).MemType and
         (PMemTuple(InternalMemArray[i]).LocalData = hMem) then
      begin
        result := i;
        exit;
      end;
    end;
  end;
{$ENDIF}

{$IFDEF FullDebugMode}
var Index : Integer;
{$ENDIF FullDebugMode}

begin
{$IFDEF FullDebugMode}
  if LocalLock(hMem) <> nil then
  begin
    Index := Find;
    if Index < 0 then
    begin
      LocalUnlock(hMem);
      raise EInvalidPointer.Create(RsInvalidLocalPointer);
    end;

    FreeMem(PMemTuple(InternalMemArray[Index]).GetMemPointer);
    FreeMem(PMemTuple(InternalMemArray[Index]));
    InternalMemArray.Delete(Index);

    LocalUnlock(hMem);
{$ENDIF FullDebugMode}
    result := LocalFree(hMem);
{$IFDEF FullDebugMode}
  end;
{$ENDIF FullDebugMode}
  hMem := 0;
end;




function JwGlobalAllocMem(uFlags: UINT; uBytes: SIZE_T): HGLOBAL;
{$IFDEF FullDebugMode}
var MemTuple : PMemTuple;
{$ENDIF FullDebugMode}
begin
  result := GlobalAlloc(uFlags,uBytes);
{$IFDEF FullDebugMode}
  if result <> 0 then
  begin
    New(MemTuple);
    GetMem(MemTuple.GetMemPointer,uBytes);
    MemTuple.MemType := false;
    MemTuple.GlobalData := result;
    InternalMemArray.Add(MemTuple);
  end;
{$ENDIF FullDebugMode}
end;

function JwGlobalFreeMem(var hMem: HGLOBAL): HGLOBAL;
{$IFDEF FullDebugMode}
  function Find : Integer;
  var i : Integer;
  begin
    result := -1;
    i := -1;
    for I := 0 to InternalMemArray.Count - 1 do
    begin
      if not PMemTuple(InternalMemArray[i]).MemType and
         (PMemTuple(InternalMemArray[i]).GlobalData = hMem) then
      begin
        result := i;
        exit;
      end;
    end;
  end;
{$ENDIF FullDebugMode}

{$IFDEF FullDebugMode}
var Index : Integer;
{$ENDIF FullDebugMode}
begin
  result := 0;
{$IFDEF FullDebugMode}
  if GlobalLock(hMem) <> nil then
  begin
    Index := Find;
    if Index < 0 then
    begin
      GlobalUnlock(hMem);
      raise EInvalidPointer.Create(RsInvalidGlobalPointer);
    end;

    FreeMem(PMemTuple(InternalMemArray[Index]).GetMemPointer);
    FreeMem(PMemTuple(InternalMemArray[Index]));
    InternalMemArray.Delete(Index);

    GlobalUnlock(hMem);
{$ENDIF FullDebugMode}

    result := GlobalFree(hMem);
{$IFDEF FullDebugMode}
  end;
{$ENDIF FullDebugMode}
  hMem := 0;
end;


procedure JwGlobalFreeAndNil(var hMem: HGLOBAL);
begin
  if hMem <> 0 then
    GlobalFree(hMem);
  hMem := 0;
end;


{$IFDEF FullDebugMode}
procedure DeleteInternalMemArray;
var i : Integer;
begin
  //we do not attempt to free the remaining TMemTuple.GetMemPointer blocks
  //instead we only remove PMemTuple memory
  for i := 0 to InternalMemArray.Count-1 do
  begin
    FreeMem(PMemTuple(InternalMemArray[i]));
    InternalMemArray[i] := nil;
  end;
  FreeAndNil(InternalMemArray);
end;
{$ENDIF}


{var S : TJwString;
    SA : TResourceTStringArray;
    Indexes : TResourceIndexArray;
    i : Integer;     }
initialization
 
  {
  S := LoadLocalizedString(50005, LANG_NEUTRAL, SUBLANG_NEUTRAL);
  S := LoadLocalizedString(50005, LANG_ENGLISH, SUBLANG_NEUTRAL, 0);
  S := LoadLocalizedString(50005, LANG_NEUTRAL, SUBLANG_SYS_DEFAULT);
  if s = '' then;
                       }
{  SetLength(Indexes,20);
  for i := 1 to 20 do
    Indexes[i-1] := 50000+i;
  SA := LoadLocalizedStringArray(Indexes,MAKELANGID(LANG_NEUTRAL,  SUBLANG_SYS_DEFAULT),0);
 }

{$IFDEF FullDebugMode}
  InternalMemArray := TList.Create;
{$ENDIF}

finalization
{$IFDEF FullDebugMode}
   DeleteInternalMemArray;
{$ENDIF}

end.

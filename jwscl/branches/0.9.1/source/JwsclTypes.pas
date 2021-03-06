{
<B>Abstract</B>Contains types that are used by the units of JWSCL 
@author(Christian Wimmer)
<B>Created:</B>03/23/2007 
<B>Last modification:</B>11/27/2007 

Project JEDI Windows Security Code Library (JWSCL)

The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy of the
License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
ANY KIND, either express or implied. See the License for the specific language governing rights
and limitations under the License.

Alternatively, the contents of this file may be used under the terms of the  
GNU Lesser General Public License (the  "LGPL License"), in which case the
provisions of the LGPL License are applicable instead of those above.        
If you wish to allow use of your version of this file only under the terms   
of the LGPL License and not to allow others to use your version of this file 
under the MPL, indicate your decision by deleting  the provisions above and  
replace  them with the notice and other provisions required by the LGPL      
License.  If you do not delete the provisions above, a recipient may use     
your version of this file under either the MPL or the LGPL License.          
                                                                             
For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html 

The Original Code is JwsclTypes.pas.

The Initial Developer of the Original Code is Christian Wimmer.
Portions created by Christian Wimmer are Copyright (C) Christian Wimmer. All rights reserved.

}
{$IFNDEF SL_OMIT_SECTIONS}
unit JwsclTypes;
// Last modified: $Date: 2007-09-10 10:00:00 +0100 $
{$I Jwscl.inc}


interface

uses
  JwaWindows,
  JwaVista,
  JwsclResource,
  JwsclStrings; //JwsclStrings, must be at the end of uses list!!!
{$ENDIF SL_OMIT_SECTIONS}

{$IFNDEF SL_IMPLEMENTATION_SECTION}
type
{$IFNDEF DELPHI6_UP}
  {<B>PCardinal</B> is defined for Delphi 5 because it does not know this types}
  PCardinal = ^Cardinal;
{$ENDIF DELPHI6_UP}

{$IFDEF DELPHI6_UP}
 {$ALIGN 4}  //warning do not remove. WinApi relies on that!
{$ELSE}
 {$A-} //[warning] Enumeration types need to be 4 bytes long (not 1 byte)
{$ENDIF DELPHI6_UP}


  {<B>TJwTokenHandle</B> is the type of a token handle}
  TJwTokenHandle   = Cardinal;
  //<B>TJwAccessMask</B> is the type of an access mask
  TJwAccessMask    = Cardinal;
  //<B>TJwThreadHandle</B> is the type of a thread handle
  TJwThreadHandle  = Cardinal;
  //<B>TJwProcessHandle</B> is the type of a process handle
  TJwProcessHandle = Cardinal;
  //<B>TJwLastError</B> is the type of a last error code
  TJwLastError     = Cardinal;
  //<B>TJwTokenAccessMask</B> defines the access mask of a token
  TJwTokenAccessMask = TJwAccessMask;
  //<B>TJwCSPHandle</B> is the type of a cryptographic service provider handle
  TJwCSPHandle     = Cardinal;
  //<B>TJwHashHandle</B> is the type of a hash handle
  TJwHashHandle    = Cardinal;
  //<B>TJwKeyHandle</B> is the type of a handle to a cryptographic key
  TJwKeyHandle = Cardinal;


  //<B>TJwSessionId</B> is the type of a Terminal Server Session Identifier
  TJwSessionId = DWORD;
  //<B>TJwState</B> is the type of a Terminal Server Session State
  TJwState = DWORD;
  //<B>TJwProcessId</B> is the type of a Terminal Server Process Identifier
  TJwProcessId = DWORD;


  TJwAceFlag  = (//e.g. inherit ACE to this folder and its sub files
    afObjectInheritAce,

    //e.g. inherit ACE to this folder sub folders
    afContainerInheritAce,

                {If enabled for an inheritable ACE, it says that when the ACE is
                copied to any children the child's copy should have all inheritance flags
                turned off, which prevents the ACE from flowing to grandchildren.
                by Keith GuideBook}
    afNoPropagateInheritAce,

    //e.g. inherit ACE not to this folder
    afInheritOnlyAce,

    //if set, the ACE is inherited from a parent (it is an indirect ACE)
    afInheritedAce,

    //unknown, TBD
    afValidInheritFlags,

    //this flag defines an successfull audit ACE entry
    afSuccessfulAccessAceFlag,

    //this flag defines an failure audit ACE entry
    afFailedAccessAceFlag
    );
  TJwAceFlags = set of TJwAceFlag;

const
   TJwAceFlagStrings: array [TJwAceFlag] of TJwString =
    (
     'OBJECT_INHERIT_ACE',
     'CONTAINER_INHERIT_ACE',
     'NO_PROPAGATE_INHERIT_ACE',
     'INHERIT_ONLY_ACE',
     'INHERITED_ACE',
     'VALID_INHERIT_FLAGS',
     'SUCCESSFUL_ACCESS_ACE_FLAG',
     'FAILED_ACCESS_ACE_FLAG'
     );

  {Apply ACE only to this folder}
  TJwAfThisFolderOnly = [];
  {Apply ACE to this folder and all sub folders and its files}
  TJwAfThisFolderAndSubFoldersAndFiles =
    [afObjectInheritAce, afContainerInheritAce];
  {Apply ACE to this folder and sub folders}
  TJwAfThisFolderAndSubFolders = [afContainerInheritAce];
  {Apply ACE to this folder and its files}
  TJwAfThisFolderAndFiles = [afObjectInheritAce];
  {Apply ACE not to this folder but to all sub folders and its files}
  TJwAfSubfoldersAndFilesOnly =
    TJwAfThisFolderAndSubFoldersAndFiles + [afInheritOnlyAce];
  {Apply ACE not to this folder but to all sub folders}
  TJwAfSubFoldersOnly =
    TJwAfThisFolderAndSubFolders + [afInheritOnlyAce];
  {Apply ACE not to this folder but to all its files}
  TJwAfFilesOnly =
    TJwAfThisFolderAndFiles + [afInheritOnlyAce];

  {Apply ACE only to this folder}
  TJwAfThisFolderOnlyNoPropagate =
    TJwAfThisFolderOnly + [afNoPropagateInheritAce];
  {Apply ACE to this folder and all direct files and direct sub folders }
  TJwAfThisFolderAndSubFoldersAndFilesNoPropagate =
    TJwAfThisFolderAndSubFoldersAndFiles + [afNoPropagateInheritAce];
  {Apply ACE to this folder and direct sub folders}
  TJwAfThisFolderAndSubFoldersNoPropagate =
    TJwAfThisFolderAndSubFolders + [afNoPropagateInheritAce];
  {Apply ACE to this folder and its direct files}
  TJwAfThisFolderAndFilesNoPropagate =
    TJwAfThisFolderAndFiles + [afNoPropagateInheritAce];
  {Apply ACE not to this folder but to all direct files and direct sub folders }
  TJwAfSubfoldersAndFilesOnlyNoPropagate =
    TJwAfSubfoldersAndFilesOnly + [afNoPropagateInheritAce];
  {Apply ACE not to this folder but to all direct sub folders}
  TJwAfSubFoldersOnlyNoPropagate =
    TJwAfSubFoldersOnly + [afNoPropagateInheritAce];
  {Apply ACE not to this folder but to all its direct files}
  TJwAfFilesOnlyNoPropagate =
    TJwAfFilesOnly + [afNoPropagateInheritAce];


  {Apply ACE only to this key}
  TJwAfThisKeyOnly       = [];
  {Apply ACE to this key and all sub keys}
  TJwAfThisKeyAndSubKeys = [afContainerInheritAce];
  {Apply ACE not to this key but to all sub key}
  TJwAfSubKeysOnly       =
    TJwAfThisKeyAndSubKeys + [afInheritOnlyAce];

  {Apply ACE only to this key}
  TAF_ThisKeyOnly_NoPropagate       = TJwAfThisKeyOnly;
  {Apply ACE to this key and all sub keys}
  TJwAfThisKeyAndSubKeysNoPropagate =
    TJwAfThisKeyAndSubKeys + [afNoPropagateInheritAce];
  {Apply ACE not to this key but to all sub key}
  TJwAfSubKeysOnlyNoPropagate       =
    TJwAfSubKeysOnly + [afNoPropagateInheritAce];




type
  TJwProgInvokeSetting = (
    {pis_0 ... pis_8 : padding stuff. Do not use. For future use.}
    pis_0,
    {Never invoke the progress function}
    pis_ProgressInvokeNever,
    {Invoke for each object}
    pis_ProgressInvokeEveryObject,
    {Invoke only for each error case}
    pis_ProgressInvokeOnError,
    {Stop propagation and return}
    pis_ProgressCancelOperation,
    {Retry operation on subtree}
    pis_ProgressRetryOperation,
    pis_1, pis_2, pis_3, pis_4,
    pis_5, pis_6, pis_7, pis_8,
    {The propagation has finished}
    pis_ProgressFinished
    );



  TJwAccessControlListType = (
    acltDiscretionary, acltAuditing, acltMandatory);
  TJwAceType = (
    actAudit,
    actAuditCallback,
    actAuditObject,
    actAuditCallbackObject,


    actMandatory,

    actAllow,
    actAllowCallback,
    actAllowObject,
    actAllowCallbackObject,

    actDeny,
    actDenyCallback,
    actDenyObject,
    actDenyCallbackObject,

    actUnknown
   );




type

  PAce = ^TAce;
  {<B>TAce</B> defines a low level access control entry data structure.
   It is used to communicate with WinAPI functions.
  TODO:[hint] migrate to JEDI API LIB
   }
  TAce = packed record
    case AceType: byte of
      ACCESS_ALLOWED_ACE_TYPE: (
        accessAllowedAce: TAccessAllowedAce);
      ACCESS_DENIED_ACE_TYPE: (
        accessDeniedAce: TAccessDeniedAce);
      SYSTEM_AUDIT_ACE_TYPE: (
        systemAuditAce: TSystemAuditAce);
  end;

  TJwEqualAceType    = (eactSameSid,
    eactSameFlags,
    eactSameAccessMask,
    eactSameType);
  TJwEqualAceTypeSet = set of TJwEqualAceType;

const
  JwAllEqualAceTypes = [eactSameSid, eactSameFlags,
    eactSameAccessMask, eactSameType];

type

  TJwExplicitAccessArray = array of  {$IFDEF UNICODE}TEXPLICITACCESSW{$ELSE}TEXPLICITACCESSA{$ENDIF};
  TJwExplicitAccess    = {$IFDEF UNICODE}TEXPLICITACCESSW;{$ELSE}TEXPLICITACCESSA;{$ENDIF}




  TJwSecurityInformationFlag    = (
    siOwnerSecurityInformation,
    siGroupSecurityInformation,
    siDaclSecurityInformation,
    siSaclSecurityInformation,
    //this flag gets or sets the mandatory integrity level
    siLabelSecurityInformation,
    //this flag protects the DACL from inheritance flowing to this SD
    siProtectedDaclSecurityInformation,
    //this flag protects the SACL from inheritance flowing to this SD
    siProtectedSaclSecurityInformation,
    //this flag removes protection from the DACL
    siUnprotectedDaclSecurityInformation,
    //this flag removes protection from the SACL
    siUnprotectedSaclSecurityInformation);

  TJwSecurityInformationFlagSet = set of TJwSecurityInformationFlag;

const
  JwAllSiFlags = [siOwnerSecurityInformation,
    siDaclSecurityInformation,
    siSaclSecurityInformation];

type
  TJwSecurityResetType = (srtNone,
    srtOwner,
    srtDacl,
    srtSacl);

  { SI_OWNER_RECURSE
    SI_RESET_DACL_TREE
    SI_RESET_SACL_TREE    }

  TJwGuidArray = array of TGUID;

  TCardinalE = -1..high(Cardinal);

  {<B>TJwInheritedFromRecord</B> is used to gather information about
   an inheritance flow
  }
  TJwInheritedFromRecord = record
    {<B>GenerationGap</B> defines the gap between the source and heirs.
    -1 defines that the gap could not be determined.}
    GenerationGap: TCardinalE;
    {<B>AncestorName</B> defines the name of the acestor. (Always unicode.
     See TJwInheritedFromArrayEx )}
    AncestorName:  WideString;
    {<B>SID</B> defines the name of the Sid which this record is dealing with.
     It looks like <SID account name>@<S-X-X...> }
    SID:           WideString;
  end;

  TJwInheritedFromArray = array of TJwInheritedFromRecord;



 // PInheritedFromEx = PInheritedFromW;
 // TInheritedFromEx = TInheritedFromW;

  {Array of an unicode TInheritedFrom record
   because GetInheritanceSource does not support ansi on all systems.
   Do not change to Ansi unless you want to
   adapt TJwSecureBaseClass.GetInheritanceSource.}
  TJwInheritedFromArrayEx = array of TInheritedFromW;

  TJwLuidArray = array of TLuid;


type
  {<B>TJwTempResetEnum</B> defines caches stored in a TJwSecureFileObject}
  TJwTempResetEnum    = (treOwner, treGroup, treDacl, treSacl);
  TJwTempResetEnumSet = set of TJwTempResetEnum;

const
  {<B>JwResetEnumSetAll</B> defines a reset state that resets all caches of a TJwSecureFileObject}
  JwResetEnumSetAll = [treOwner, treGroup, treDacl, treSacl];

type
//TODO: reconsider that!
{$IFNDEF FPC}
  jwaWindows_PSID = jwaWindows.PSID;
  jwaWindows_PACL = jwaWindows.PACL;
  jwaWindows_PSecurity_Descriptor = jwaWindows.PSecurity_Descriptor;
{$ELSE}
   jwaWindows_PSID = jwaWindows.PSID;
   jwaWindows_PACL = jwaWindows.PACL;
   jwaWindows_PSecurity_Descriptor = jwaWindows.PSecurity_Descriptor;
{$ENDIF}

  {<B>TJwSecurityDescriptorControl</B> defines control flags which defines a security descriptor.
  }
  TJwSecurityDescriptorControl =
    (sdcOwnerDefaulted,
    sdcGroupDefaulted,
    sdcDaclPresent,
    sdcDaclDefaulted,
    sdcSaclPresent,
    sdcSaclDefaulted,
    sdcDaclAutoInheritReq,
    sdcSaclAutoInheritReq,
    sdcDaclAutoInherited,
    sdcSaclAutoInherited,
    sdcDaclProtected,
    sdcSaclProtected,
    sdcRmControlValid,
    sdcSelfRelative
    );

  TJwSecurityDescriptorControlSet = set of TJwSecurityDescriptorControl;

  {<B>TJwACLProtection</B> control the protection of an acl.}
  TJwACLProtection =
    ({The acl is not protected and can contain inherited ace.
     This flag is only for reading purpose. Use aclpForceUnprotect to
     actually unprotect an acl. }
     aclpUnprotected,
     {The acl is protected or can be made protected against inherited ace.
      If made protected all access control elements are converted to explicit ones.
     }
     aclpProtected,
     {This flag unprotects a protected acl and restores inheritance flow.
      If explicit ace element are available they will remain intact.
      However duplicate elements are ignored and remain in the ACL.
      }
     aclpForceUnprotect);


  {<B>TJwTreeSetType</B> defines the type of change to a object tree}
  TJwTreeSetType = ({Set security information}
    tstSet,
    {remove security information and reset it}
    tstReset);


  TJwRootRegKey = (//use string in root key
    rrkString,
    rrkLocalMachine,
    rrkCurrentUser,
    rrkUsers,
    rrkCurrentConfig,
    rrkClassesRoot);


type
  TJwRootTuple = record
    RootName: TJwString;
    RootKey:  TJwRootRegKey;
    Key:      HKEY;
  end;

  TJwRootKeyEnum = (
    rkeLocal,
    rkeCurrentUser,
    rkeUsers,
    rkeConfig,
    rkeClasses
    );

  TJwKeyRootTupleArray = array[TJwRootKeyEnum] of TJwRootTuple;

const
  {<B>JwKeyRootTupleArray</B> defines a connection between root key handle and string
   DO NOT LOCALIZE!! 
  }
  JwKeyRootTupleArray: TJwKeyRootTupleArray =
    (
    (RootName: 'MACHINE';
    RootKey: rrkLocalMachine;
    Key: HKEY_LOCAL_MACHINE),
    (RootName: 'CURRENT_USER';
    RootKey: rrkCurrentUser;
    Key: HKEY_CURRENT_USER),
    (RootName: 'USERS';
    RootKey: rrkUsers;
    Key: HKEY_USERS),
    (RootName: 'CONFIG';
    RootKey: rrkCurrentConfig;
    Key: HKEY_CURRENT_CONFIG),
    (RootName: 'CLASSES_ROOT';
    RootKey: rrkClassesRoot;
    Key: HKEY_CLASSES_ROOT)
    );
  NIL_RootTuple: TJwRootTuple =
    (RootName: '';
    RootKey: rrkString;
    Key: 0);



type
  TJwRightsMapping = record
    Right: Cardinal;
    Name:  WideString;
    Flags: Cardinal;
    {<B>StringId</B> contains the resource string index
     0: use default index
     >0: use relative index (relative of first start index)
     <0: use absolute index (-index)
    }
    StringId : Integer; 
  end;

  {<B>TJwSecurityDialogFlag</B> defines the flags of the TJwSecurityDescriptorDialog .}
  TJwSecurityDialogFlag  = (
    sdfEditDacl,
    sdfEditSacl,
    sdfEditOwner,
    sdfContainer,
    sdfReadOnly,
    sdfAdvanced,
    sdfReset,
    sdfOwnerReadOnly,
    sdfEditProperties,
    sdfOwnerRecurse,
    sdfNoAclProtect,
    sdfNoTreeApply,
    sdfServerIsDc,
    sdfResetDaclTree,
    sdfResetSaclTree,
    sdfObjectGuid,
    sdfEditEffective,
    sdfResetDacl,
    sdfResetSacl,
    sdfResetOwner,
    sdfNoAdditionalPermission,
    sdfMayWrite,
    sdfPageTitle);
  TJwSecurityDialogFlags = set of TJwSecurityDialogFlag;

const
  JwSdfEditAll = [sdfEditDacl, sdfEditOwner, sdfEditSacl];


type
  TJwSecurityPageType = (
    sptPageDacl,
    sptPageAdvPerm,
    sptPageSacl,
    sptPageOwner,
    sptPageEffective,
    sptPageTakeOwnerShip,
    sptPadding1,
    sptPadding2,
    sptPadding3,
    sptPadding4,
    sptPadding5,
    sptPadding6,
    sptPadding7,
    sptPadding8,
    sptPadding9,
    sptAclWindow,
    sptAdvWindow
    );

const
  NULL_GUID: TGUID =
    (D1: 0; D2: 0; D3: 0;
    D4: (0, 0, 0, 0, 0, 0, 0, 0));
  GUID_NULL: TGUID =
    (D1: 0; D2: 0; D3: 0;
    D4: (0, 0, 0, 0, 0, 0, 0, 0));



type
  TTrusteeEx = {$IFDEF UNICODE}TTrusteeW{$ELSE}TTrusteeA{$ENDIF};


  TJwAccessMaskArray     = array of TJwAccessMask;
  TJwObjectTypeListArray = array of TObjectTypeList;


  TJwSidClassName = (scnNone, scnComputer, scnUser, scnGroup,
    scnUnknown);

  {<B>TJwSidInfoRecord</B> provides information about a SID that could not be
  translated into a human readable name.
  }
  TJwSidInfoRecord = record
    pSid:      TObject;{TJwSecurityId;}
    {<B>sUPN</B> defines the users principal name for display (ex. full name)}
    sCommonName,
    {<B>sUPN</B> defines the users principal logon name}
    sUPN:      WideString;
    {<B>sClass</B> defines which type the user belongs to (computer, user, group)}
    sClass:    TJwSidClassName;
    {<B>Exception</B> contains the exception which occured when TJwSecurityDescriptorDialog
     tried to translate the Sid into the Name.
     This member can be nil if the Sid could be translated into a name.
     In this case sCommonName contains the translated name.
    }
    Exception: TObject;
  end;
  TJwSidInfoRecordArray = array of TJwSidInfoRecord;


 {TCreationFlags defines how a TDesktop object is to be created}
  TJwDesktopCreationFlag = (
    //<B>	dcfOpen)</B> creates a new desktop with the given flags
    dcfCreate, 
	//<B>	dcfOpen)</B> opens an existing desktop with the given flags)
	dcfOpen);




   {TJwSecurityDesktopFlag is used when creating a new desktop.}
  TJwSecurityDesktopFlag  = (
   //Do not use the flag!
   dfPad0, 
   //dfAllowOtherAccountHook Use this flag, if you want to allow other applications to create hooks in your desktop
   dfAllowOtherAccountHook);


   {TJwSecurityDesktopFlags is a set of desktop flags.
    Actually it can only contain dfAllowOtherAccountHook or nothgin :
  Use [] as a aparameter if you don't want other applications to create hooks. Otherwise
  use [dfAllowOtherAccountHook].
  Never use [dfPad0]!
  See also TJwSecurityDesktopFlags  }
  TJwSecurityDesktopFlags = set of TJwSecurityDesktopFlag;


  {see http://msdn2.microsoft.com/en-us/library/aa379624.aspx}
  TJwSidAttribute  = (
    sidaUnknown,
    sidaGroupMandatory,
    sidaGroupEnabledByDefault,
    sidaGroupEnabled,
    sidaGroupOwner,
    sidaGroupUseForDenyOnly,
    sidaGroupLogonId,
    sidaGroupResource,
    sidaGroupIntegrity,         //0x00000020L
    sidaGroupIntegrityEnabled, //0x00000040L
    sidaPad0,
    sidaPad1,
    sidaPad2,
    sidaPad3,
    sidaPad4,
    sidaPad5
    );           
  TJwSidAttributeSet = set of TJwSidAttribute;

  TJwSidAttributesStringArray = array[TJwSidAttribute] of TJwString;

  TJwSiAccessArray = array of SI_ACCESS;

  TJwStringArray = array of AnsiString;

  TJwIntegrityLabelType = (
    iltNone,
    iltLow,
    iltMedium,
    iltHigh,
    iltSystem,
    iltProtected
    );

type
   TJwSecurityObjectInformation = record
    Level: TCardinalE;
    ObjectGuid: TGuid;
    ObjectName: TJwString;
    ObjectType: TGuid;
    ServerName: TJwString;
  end;

  TJwSecurityObjectInformationFlag =
   (soifLevel,
    soifObjectGuid,
    soifObjectName,
    soifObjectType,
    soifServerName
   );
  TJwSecurityObjectInformationFlagSet = set of TJwSecurityObjectInformationFlag;

  TJwGetAccessCheckType =
   (gactGetSecurity,
    gactSetSecurity);
  TJwGetAccessCheckTypeSet = set of TJwGetAccessCheckType;

  TJwGetInheritFlagsType =
   (giftCreatePrivate,
    giftSetPrivate);


  TJwInheritFlag = (
    //  SEF_DACL_AUTO_INHERIT 0x01 The new discretionary access control list (DACL) contains ACEs inherited from the DACL of ParentDescriptor, as well as any explicit ACEs specified in the DACL of CreatorDescriptor. If this flag is not set, the new DACL does not inherit ACEs.
    ifDaclAutoInherit,

    //SEF_SACL_AUTO_INHERIT 0x02 The new system access control list (SACL) contains ACEs inherited from the SACL of ParentDescriptor, as well as any explicit ACEs specified in the SACL of CreatorDescriptor. If this flag is not set, the new SACL does not inherit ACEs.
    ifSaclAutoInherit,

    //SEF_DEFAULT_DESCRIPTOR_FOR_OBJECT 0x04 CreatorDescriptor is the default descriptor for the type of object specified by ObjectType. As such, CreatorDescriptor is ignored if ParentDescriptor has any object-specific ACEs for the type of object specified by the ObjectType parameter. If no such ACEs are inherited, CreatorDescriptor is handled as though this flag were not specified.
    ifDefaultDescriptor,

    //SEF_AVOID_PRIVILEGE_CHECK 0x08 The function does not perform privilege checking. If the SEF_AVOID_OWNER_CHECK flag is also set, the Token parameter can be NULL. This flag is useful while implementing automatic inheritance to avoid checking privileges on each child updated.
    ifAvoidPrivilegeCheck,

    //SEF_AVOID_OWNER_CHECK 0x10 The function does not check the validity of the owner in the resultant NewDescriptor as described in Remarks below. If the SEF_AVOID_PRIVILEGE_CHECK flag is also set, the Token parameter can be NULL.
    ifAvoidOwnerCheck,

    //SEF_DEFAULT_OWNER_FROM_PARENT 0x20 The owner of NewDescriptor defaults to the owner from ParentDescriptor. If not set, the owner of NewDescriptor defaults to the owner of the token specified by the Token parameter. The owner of the token is specified in the token itself. In either case, if the CreatorDescriptor parameter is not NULL, the NewDescriptor owner is set to the owner from CreatorDescriptor.
    ifDefaultOwnerFromPArent,

    //SEF_DEFAULT_GROUP_FROM_PARENT 0x40 The group of NewDescriptor defaults to the group from ParentDescriptor. If not set, the group of NewDescriptor defaults to the group of the token specified by the Token parameter. The group of the token is specified in the token itself. In either case, if the CreatorDescriptor parameter is not NULL, the NewDescriptor group is set to the group from CreatorDescriptor.
    ifDefaultGroupFromParent,

    //SEF_MACL_NO_WRITE_UP 0x100 A principal with a mandatory level lower than that of the object cannot write to the object.
    ifMaclNoWriteUp,

    //SEF_MACL_NO_READ_UP 0x200 A principal with a mandatory level lower than that of the object cannot read the object.
    ifMaclNoReadUp,

    //SEF_MACL_NO_EXECUTE_UP 0x400 A principal with a mandatory level lower than that of the object cannot execute the object.
    ifMaclNoExecuteUp,

    //SEF_AVOID_OWNER_RESTRICTION 0x1000  Any restrictions specified by the owner of the object's parent that would limit the caller's ability to specify a DACL in the ObjectsSecurityDescriptor are ignored.
    ifAvoidOwnerRestriction
   );
   TJwInheritFlagSet = set of TJwInheritFlag;

   {<B>TJwCredentialFlag</B> defines the winapi credential flags as an enumeration type.}
  TJwCredentialFlag    = (
    cfFlagsAlwaysShowUi
    //Specifies that a user interface will be shown even if the credentials can be returned from an existing credential in credential manager. This flag is permitted only if CREDUI_FLAGS_GENERIC_CREDENTIALS is also specified.
    , cfFlagsDoNotPersist
    //Do not store credentials or display check boxes. You can pass CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX with this flag to display the Save check box only, and the result is returned in the pfSave output parameter.
    , cfFlagsExcludeCertificates
    //Populate the combo box with user name/password only. Do not display certificates or smart cards in the combo box.
    , cfFlagsExpectConfirmation
    //Specifies that the caller will call CredUIConfirmCredentials after checking to determine whether the returned credentials are actually valid. This mechanism ensures that credentials that are not valid are not saved to the credential manager. Specify this flag in all cases unless CREDUI_FLAGS_DO_NOT_PERSIST is specified.
    , cfFlagsGenericCredentials
    //Consider the credentials entered by the user to be generic credentials.
    , cfFlagsIncorrectPassword
    //Notify the user of insufficient credentials by displaying the "Logon unsuccessful" balloon tip.
    , cfFlagsPersist
    //Do not show the Save check box, but the credential is saved as though the box were shown and selected.
    , cfFlagsRequestAdministrator
    //Populate the combo box with local administrators only. Windows XP Home Edition:  This flag will filter out the well-known Administrator account.
    , cfFlagsRequireCertificate
    //Populate the combo box with certificates and smart cards only. Do not allow a user name to be entered.
    , cfFlagsRequireSmartCard
    //Populate the combo box with certificates or smart cards only. Do not allow a user name to be entered.
    , cfFlagsServerCredential
    //This flag is meaningful only in locating a matching credential to prefill the dialog box, should authentication fail. When this flag is specified, wildcard credentials will not be matched. It has no effect when writing a credential. CredUI does not create credentials that contain wildcard characters. Any found were either created explicitly by the user or created programmatically, as happens when a RAS connection is made.
    , cfFlagsShowSaveCheckBox
    //If the check box is selected, show the Save check box and return TRUE in the pfSave output parameter, otherwise, return FALSE. CREDUI_FLAGS_DO_NOT_PERSIST must be specified to use this flag. Check box uses the value in pfSave by default.
    , cfFlagsUserNameTargetCredentials
    //The credential is a "runas" credential. The TargetName parameter specifies the name of the command or program being run. It is used for prompting purposes only.
    );
  {<B>TJwCredentialFlagSet</B> defines the winapi credential flags bitmask as a set}
  TJwCredentialFlagSet = set of TJwCredentialFlag;


  {<B>TJwCryptProtectFlag</B> defines flag states for encryption}
  TJwCryptProtectFlag =
   (//data can only be decrypted on the same machine
    cfLocalMachine,
    //do not use a prompt
    cfUiFobidden{,
    cfAudit,
    cfVerifyProtection});
  TJwCryptProtectFlagSet = set of  TJwCryptProtectFlag;

  {<B>TJwCryptProtectOnPromptFlag</B> defines when a prompt should occur.}
  TJwCryptProtectOnPromptFlag =
   (cppf_Pad0,
    //prompt on data protection
    cppf_PromptOnProtect,
    //prompt on data unprotection
    cppf_PromptOnUnprotect);
  TJwCryptProtectOnPromptFlagSet = set of TJwCryptProtectOnPromptFlag;

  PJwGetMemBlob = ^TJwGetMemBlob;
  {<B>TJwGetMemBlob</B> defines a blob that contains data created
   by GetMem}
  TJwGetMemBlob = record
    //Data created by GetMem
    Data : Pointer;
    //Size of data
    Size : Cardinal;
  end;

  {<B>TJwMemoryType</B> defines a memory manager type}
  TJwMemoryType =
   (//delphi memory manager
    mtGetMem,
    //Local windows api memory manager
    mtLocal,
    //Global windows api memory manager
    mtGlobal
    );

  {<B>TJwProtectMemoryFlag</B> defines who can decrypt a memory block}
  TJwProtectMemoryFlag =
   (//only the same process can decrypt the memory
    pmSameProcess,
    //other processes can decrypt the memory
    pmCrossProcess,
    //only the same user can decrypt the memory
    pmSameLogon
    );
  TJwProtectMemoryFlagSet = set of TJwProtectMemoryFlag;

  {<B>TJwCopyFlag</B> defines the mechanism how an instance
   will be treated it added to a list.
   If you use this flag you must also include this source (with comment)
   on every implementation.
   <code lang="Delphi">
   (*this const declaration prevents changing the type TJwCopyFlag
    without notice of this implementation. The compiler will
    show an error and source code must be adapted.
    This code will be removed by the optimizer
    *)
    const CopyFlagCheck : array[TJwCopyFlag] of byte = (0,1);
   </code>
  }
  TJwCopyFlag =(
     //Copy the instance data into a newly created instance
     cfCopyInstance,
     //use the given instance and simply add it to the list
     cfPointAtInstance);

  //<B>TJwCSPType</B> defines the type of a cryptographic service provider.
  //See http://msdn2.microsoft.com/en-us/library/aa380244.aspx for more information.
  TJwCSPType = (
     //This value is returned by conversion functions only.
     //It should be used solely for error checking.
     ctUnknown,
     ctRsaFull,
     {exclude ctRsaAes, PROV_RSA_AES is not in JwaWinCrypt.pas yet}
     {}
     ctRsaSig,
     ctRsaSchannel,
     ctDss,
     ctDssDh,
     ctDhSchannel,
     ctFortezza,
     ctMsExchange,
     ctSsl);

  //<B>TJwCSPCreationFlag</B> defines the flags for a call to CryptAcquireContext
  TJwCSPCreationFlag = (
     //This flag is specified when there is no need for access to private keys.
     ccfVerifyContext,
     //Specify this flag to create the key container with the specified name.
     ccfNewKeyset,
     //This flag causes the CSP to treat the key container as a machine key container.
     ccfMachineKeyset,
     {ccfDeleteKeyset, excluded since this is not a regular acquisition}
     {This flag prevents the CSP from displaying any UI.}
     ccfSilent);

  TJwCSPCreationFlagSet = set of TJwCSPCreationFlag;

  //Hash algorithms supported in Windows XP
  TJwHashAlgorithm = (
     //This value is returned by conversion functions only.
     //It should be used solely for error checking.
     haUnknown,
     haMD2,
     haMD4,
     haMD5,
     haSHA,
     haMAC,
     haHMAC);

const KeylessHashAlgorithms = [haMD2..haSHA];

type
//General-purpose encryption algorithms. See
//http://msdn2.microsoft.com/en-us/library/ms937014.aspx for more
//information
  TJwEncryptionAlgorithm = (
     eaUnknown,
     eaRsaSign,
     eaRsaKeyX,
     eaDes,
     ea3Des,
     ea3Des112,
     eaRc2,
     eaRc4,
     eaRc5,
     eaSeal,
     eaDhSf,
     eaDhEphem,
     eaAgreedKeyAny,
     eaKeaKeyX,
     eaSkipjack,
     eaTek,
     eaCylinkMek
     );

//The flags needed for calls to TJwCryptKey.Import,
//.ExportKey, .Generate and .Derive
  TJwKeyFlag = (kfCreateSalt,
                {kfArchivable,}
                {}
                kfPreGen,
                kfExportable,
                kfNoSalt,
                kfUserProtected,
                kfOaep,
                kfUpdateKey,
                kfDestroyKey,
                kfSSL2Fallback);

  TJwKeyFlagSet = set of TJwKeyFlag;

const
  //Flags allowed for a call to TJwCryptKey.Generate
  GenerateKeyFlags = [kfCreateSalt..kfUserProtected];
  //Flags allowed for a call to TJwCryptKey.Derive
  DeriveKeyFlags   = [kfCreateSalt, kfExportable, kfNoSalt, kfUpdateKey];
  //Flags allowed for a call to TJwCryptKey.Import
  ImportKeyFlags   = [kfExportable..kfOaep];
  //Flags allowed for a call to TJwCryptKey.ExportKey
  ExportKeyFlags   = [kfOaep, kfDestroyKey, kfSSL2Fallback];
  //Flags allowed for a call to TJwCryptKey.Encrypt
  EncryptKeyFlags  = [kfOaep];
  //Flags allowed for a call to TJwCryptKey.Decrypt
  DecryptKeyFlags  = [kfOaep];
type
  {Each key container usually contains two key pairs.
   Functions require a parameter of type <B>TJwKeyPairType</B> if the
   programmer should decide which of the key pairs should be used.}
  TJwKeyPairType = (kptKeyExchange,
                    kptSignature,
                    kptUnknown);

    {An array of <B>TJwEnumProviderEntry</B> is returned by TJwCryptProvider.EnumProviders
   and TJwCryptProvider.EnumProviderTypes. The meaning of Name
   depends on the function.}
  TJwEnumProviderEntry = record
  //The CSP type
    ProviderType: TJwCSPType;
  //Either the name of the provider or the friendly name of the type
    Name:         TJwString;
  end;
  TJwEnumProviderArray = array of TJwEnumProviderEntry;

  {An array of <B>TJwEnumAlgorithmsEntry</B> is returned by TJwCryptProvider.EnumAlgorithms.
   It is mostly the same as PROV_ENUMALGS_EX (see
   http://msdn2.microsoft.com/en-us/library/aa387441.aspx), but
   uses delphi strings.}
  TJwEnumAlgorithmsEntry = record
  //The algorithm as a Windows ALG_ID.
  //This value can be useful if HashAlgType/EncrAlgType is haUnknown/eaUnknown.
    AlgId:         ALG_ID;
  //The default key length for the algorithm
    DefaultKeyLen: Cardinal;
  //The minimal key length for the algorithm
    MinKeyLen:     Cardinal;
  //The maximal key length for the algorithm
    MaxKeyLen:     Cardinal;
  //The number of protocols supported
    ProtocolNum:   Cardinal;
  //The short name of the algorithm
    ShortName:     TJwString;
  //The long name of the algorithm
    LongName:      TJwString;
  //Is this a hash algorithm?
    case HashAlgorithm: Boolean of
     True:  (HashAlgType: TJwHashAlgorithm);
     False: (EncrAlgType: TJwEncryptionAlgorithm)
  end;
  TJwEnumAlgorithms = array of TJwEnumAlgorithmsEntry;

  //<B>TJwKeyExportKind</B> specifies how a key should be exported. See
  //http://msdn2.microsoft.com/en-us/library/ms938025.aspx
  //for more information
  TJwKeyExportKind = (
  //Only for Schannel CSPs
    kekOpaque,
  //Export the whole key pair
    kekPrivate,
  //Export only the public key - no encryption necessary
    kekPublic,
  //Used for symmetric session keys, encrypted with a public key
    kekSimple,
  //Use no encryption
    kekPlainText,
  //Ued to export session keys encrypted with another session key
    kekSymmetricWrap);

  {<B>TJwACLProtectionState</B> is used by TJwSecureFileObject to set inheritance protection.
   Do not mix up with TJwACLProtection which is used by TJwSecurityDescriptor
   to set and get the protection state.
  }
  TJwACLProtectionState =
   (//does not change state
    apNone,
    //block inheritance flow
    apProtected,
    //unblock inheritance flow
    apUnprotected);

  TJwMandatoryPolicy = (mpNoWriteUp, mpNoReadUp, mpNoExecuteUp);
  TJwMandatoryPolicyFlagSet = set of TJwMandatoryPolicy;

  TJwSharedHandle = (shShared, shOwned);

  TJwAuthZResourceManagerFlag =
    ({The resource manager is created with all flags set
      This needs the SE_SECURITY_NAME privilege activated. }
     authRM_Default,
     {The resource manager does not use auditing}
     authRM_NoAudit,
     {The resource manager tries initialize with a set thread token.}
     authRM_InitializeUnderImpersonation
     );
  TJwAuthZResourceManagerFlags = set of TJwAuthZResourceManagerFlag;

  TAuthZSidContextFlag =
    (
     authZSF_Default,
     authZSF_SkipTokenGroups,
     authZSF_RequireS4ULogon,
     authZSF_ComputePrivleges
     );
  TAuthZSidContextFlags = set of TAuthZSidContextFlag;

  TJwObjectTypeArray = array of TObjectTypeList;


  TJwReplyErrorEnum = (reSuccess, rePrivilegeNotHeld, reAccessDenied, reUnknown);
  TJwReplyErrorEnumArray = array of TJwReplyErrorEnum;


  TJwCardinalArray = array of Cardinal;


  TJwRequestedTokenType = (rttAuto, rttTokenPrimary, rttTokenImpersonation);

  TJwTokenMandatoryPolicy = (
    tmpOff,
    tmpNoWriteUp,
    tmpNewProcessMin);

  TJwTokenMandatoryPolicies = set of TJwTokenMandatoryPolicy;

  TJwPrivCheck = (
    pcDefault,
    pcAllPrivsEnabled);

  TWellKnownSidTypeSet = set of TWellKnownSidType;

  TJwProfileMember = (
    pmFlags,
    pmUserName,
    pmProfilePath,
    pmDefaultPath,
    pmServerName,
    pmPolicyPath
  );

  TJwProfileMembers = set of TJwProfileMember;

  {<B>TJwProfileInfo</B> contains and receives information
   about a users profile.
  }
  TJwProfileInfo = record
    // See flags above
    Flags: DWORD;
    // User name (required)
    UserName: TJwString;
    // Roaming profile path (optional, can be NULL)
    ProfilePath: TJwString;
    // Default user profile path (optional, can be NULL)
    DefaultPath: TJwString;
    // Validating domain controller name in netbios format (optional, can be NULL but group NT4 style policy won't be applied)
    ServerName: TJwString;
    // Path to the NT4 style policy file (optional, can be NULL)
    PolicyPath: TJwString;
    // Filled in by the function.  Registry key handle open to the root.
    Profile: HANDLE;
  end;


  TJwPointerType = (
    ptUnknown,
    ptNew,
    ptGetMem,
    ptLocalAlloc,
    ptHandle,
    ptClass);

  TJwJobLimit = (
    jlWORKINGSET,
    jlPROCESSTIME,
    jlJOBTIME,
    jlACTIVEPROCESS,
    jlAFFINITY,
    jlPRIORITYCLASS,
    jlPRESERVEJOBTIME,
    jlSCHEDULINGCLASS,
    jlPROCESSMEMORY,
    jlJOBMEMORY,
    jlDIEONUNHANDLEDEXCEPTION,
    jlBREAKAWAYOK,
    jlSILENTBREAKAWAYOK,
    jlKILLONJOBCLOSE,
    jlRESERVED2,
    jlRESERVED3,
    jlRESERVED4,
    jlRESERVED5,
    jlRESERVED6,
    jlNone
  );
  TJwJobLimits = set of TJwJobLimit;

  TJwJobUiLimit = (
    juilHANDLES,
    juilREADCLIPBOARD,
    juilWRITECLIPBOARD,
    juilSYSTEMPARAMETERS,
    juilDISPLAYSETTINGS,
    juilGLOBALATOMS,
    juilDESKTOP,
    juilEXITWINDOWS,
    juilNone
  );
  TJwJobUiLimits = set of TJwJobUiLimit;

  TJwJobMessage = (
    jmsgUnknown,
    jmsgACTIVEPROCESSZERO,
    jmsgENDOFPROCESSTIME,
    jmsgACTIVEPROCESSLIMIT,
    jmsgPROCESSMEMORYLIMIT,
    jmsgJOBMEMORYLIMIT,
    jmsgNEWPROCESS,
    jmsgEXITPROCESS,
    jmsgABNORMALEXITPROCESS,
    jmsgENDOFJOBTIME
  );
  TJwJobMessages = set of TJwJobMessage;


  TJwRightType = (
    rtUnknown,
    rtNone,
    rtGeneric,
    rtReserved,
    rtMaximum,
    rtSystem,
    rtStandard,
    rtSpecific);

  TJwProcessParameterType = (
    pptHandle,
    pptID);

  {<B>TJwJobTermination</B> defines how processes in job objects are terminated
   when the job list instance is freed.}
  TJwJobTermination = (
    {Terminate all processes in all job objects, ignoring TJwJobObject.TerminateOnDestroy}
    jtAll,
    {Do not terminate any processes in all job objects, ignoring TJwJobObject.TerminateOnDestroy}
    jtNone,
    {Depending on TJwJobObject.TerminateOnDestroy terminate processes or leave them alive.}
    jtSubjection
  );

  TJwUserDataCopy = (
    //copy given memory into extra memory
    ucCopyMemory,
    //use given memory
    ucUseMemory);


{$ENDIF SL_IMPLEMENTATION_SECTION}

{$IFNDEF SL_OMIT_SECTIONS}
implementation
{$ENDIF SL_OMIT_SECTIONS}




{$IFNDEF SL_OMIT_SECTIONS}
initialization
{$ENDIF SL_OMIT_SECTIONS}

{$IFNDEF SL_INITIALIZATION_SECTION}
{$ENDIF SL_INITIALIZATION_SECTION}

{$IFNDEF SL_OMIT_SECTIONS}
end.
{$ENDIF SL_OMIT_SECTIONS}

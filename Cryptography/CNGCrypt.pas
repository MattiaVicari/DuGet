unit CNGCrypt;

// https://docs.microsoft.com/it-it/windows/win32/seccng/encrypting-data-with-cng

interface

uses
  Winapi.Windows, System.Classes, Winapi.Messages,
  System.SysUtils, System.Variants;

type
  TCNGCrypt = class
  private
    FHAesAlg: Pointer;
    FHAesKey: Pointer;
    FKeyObject, FIVObject: Pointer;
    FIV, FKey: TBytes;
    FUseIVBlock: Boolean;
    procedure ReleaseResources;
    procedure CreateSymmetricKey(var CbKeyObject, CbBlockLen: DWORD);
    procedure CreateIV(var IVData: TBytes; CbBlockLen: DWORD);
  public
    ///  <summary>
    ///  Pass True to insert the IV at the first block during the encryption.
    ///  For the decryption operation, will be read the IV from the first block.
    ///  If you set this property to False, you have to provide the IV for both the encryption
    ///  and decryption procedures.
    ///  </summary>
    property UseIVBlock: Boolean read FUseIVBlock write FUseIVBlock;

    property Key: TBytes read FKey write FKey;
    ///  <summary>
    ///  The initialization vector to use. If you don't provide this data, one
    ///  will be created randomly.
    ///  </summary>
    property IV: TBytes read FIV write FIV;

    procedure Encrypt(Input, Output: TStream);
    procedure Decrypt(Input, Output: TStream);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Math,
  WinApi.CNG;

procedure ArrayMove(const Source: array of Byte; var Dest: array of Byte);
begin
  Move(Source, Dest, Length(Source));
end;

{ TCrypt }

constructor TCNGCrypt.Create;
begin
  FUseIVBlock := True;
end;

procedure TCNGCrypt.CreateIV(var IVData: TBytes; CbBlockLen: DWORD);
var
  I: Integer;
  IVLen: DWORD;
begin
  // Generate IV if it's not provided
  if Length(IVData) = 0 then
  begin
    SetLength(IVData, CbBlockLen);
    for I := Low(IVData) to High(IVData) do
      IVData[I] := RandomRange(0, 255);
  end;

  // Determine whether the cbBlockLen is not longer than the IV length.
  IVLen := Length(IVData);
  if CbBlockLen > IVLen then
    raise Exception.Create('Block length is longer than the provided IV length');

  // Allocate a buffer for the IV. The buffer is consumed during the
  // encrypt/decrypt process.
  FIVObject := HeapAlloc(GetProcessHeap, 0, CbBlockLen);
  if not Assigned(FIVObject) then
    raise Exception.Create('Memory allocation failed');
  ArrayMove(IVData, TBytes(FIVObject));
end;

procedure TCNGCrypt.CreateSymmetricKey(var CbKeyObject, CbBlockLen: DWORD);
var
  Status: Integer;
  CbData: DWORD;
begin
  CbKeyObject := 0;
  CbData := 0;
  CbBlockLen := 0;

  Status := BCryptOpenAlgorithmProvider(FHAesAlg, BCRYPT_AES_ALGORITHM, '', 0);
  if not Succeeded(Status) then
    raise Exception.Create('BCryptOpenAlgorithmProvider error: ' + IntToStr(Status));

  // Calculate the size of the buffer to hold the KeyObject.
  Status := BCryptGetProperty(FHAesAlg,
                              BCRYPT_OBJECT_LENGTH,
                              CbKeyObject,
                              SizeOf(DWORD),
                              CbData,
                              0);
  if not Succeeded(Status) then
    raise Exception.Create('BCryptGetProperty error: ' + IntToStr(Status));

  // Allocate the key object on the heap.
  FKeyObject := HeapAlloc(GetProcessHeap, 0, CbKeyObject);
  if not Assigned(FKeyObject) then
    raise Exception.Create('Memory allocation failed');

  // Calculate the block length for the IV.
  Status := BCryptGetProperty(FHAesAlg,
                              BCRYPT_BLOCK_LENGTH,
                              CbBlockLen,
                              SizeOf(DWORD),
                              CbData,
                              0);
  if not Succeeded(Status) then
    raise Exception.Create('BCryptGetProperty error: ' + IntToStr(Status));

  Status := BCryptSetProperty(FHAesAlg,
                              BCRYPT_CHAINING_MODE,
                              BCRYPT_CHAIN_MODE_CBC,
                              Length(BCRYPT_CHAIN_MODE_CBC),
                              0);
  if not Succeeded(Status) then
    raise Exception.Create('BCryptSetProperty error: ' + IntToStr(Status));

  // Generate the key from supplied input key bytes.
  Status := BCryptGenerateSymmetricKey(FHAesAlg,
                                      FHAesKey,
                                      FKeyObject,
                                      CbKeyObject,
                                      Pointer(FKey),
                                      Length(FKey),
                                      0);
  if not Succeeded(Status) then
    raise Exception.Create('BCryptGenerateSymmetricKey error: ' + IntToStr(Status));

end;

procedure TCNGCrypt.Decrypt(Input, Output: TStream);
var
  Status: Integer;
  CbKeyObject, CbBlockLen, CbCipherData, CbPlainText: DWORD;
  CipherText, PlainText: Pointer;
  CipherData: TBytes;
begin
  CipherText := nil;
  CbKeyObject := 0;
  CbBlockLen := 0;
  CbPlainText := 0;

  try
    CreateSymmetricKey(CbKeyObject, CbBlockLen);

    if not FUseIVBlock then
    begin
      SetLength(CipherData, Input.Size);
      Input.Position := 0;
      Input.Read(CipherData, Input.Size);
    end
    else
    begin
      SetLength(CipherData, Input.Size - CbBlockLen);
      SetLength(FIV, CbBlockLen);
      Input.Position := 0;
      Input.Read(FIV, CbBlockLen);
      Input.Read(CipherData, Input.Size - CbBlockLen);
    end;

    CreateIV(FIV, CbBlockLen);

    CbCipherData := Length(CipherData);
    CipherText := HeapAlloc(GetProcessHeap, 0, CbCipherData);
    if not Assigned(CipherText) then
      raise Exception.Create('Memory allocation failed');
    ArrayMove(CipherData, TBytes(CipherText));

    Status := BCryptDecrypt(FHAesKey,
                            CipherText,
                            CbCipherData,
                            nil,
                            FIVObject,
                            CbBlockLen,
                            nil,
                            0,
                            CbPlainText,
                            BCRYPT_BLOCK_PADDING);
    if not Succeeded(Status) then
      raise Exception.Create('BCryptDecrypt error: ' + IntToStr(Status));

    PlainText := HeapAlloc(GetProcessHeap, 0, CbPlainText);
    if not Assigned(PlainText) then
      raise Exception.Create('Memory allocation failed');

    Status := BCryptDecrypt(FHAesKey,
                            CipherText,
                            CbCipherData,
                            nil,
                            FIVObject,
                            CbBlockLen,
                            PlainText,
                            CbPlainText,
                            CbPlainText,
                            BCRYPT_BLOCK_PADDING);
    if not Succeeded(Status) then
      raise Exception.Create('BCryptDecrypt error: ' + IntToStr(Status));

    Output.Position := 0;
    Output.Write(TBytes(PlainText), CbPlainText);

  finally
    if Assigned(CipherText) then
      HeapFree(GetProcessHeap, 0, CipherText);
    ReleaseResources;
  end;
end;

destructor TCNGCrypt.Destroy;
begin
  ReleaseResources;
  inherited;
end;

procedure TCNGCrypt.Encrypt(Input, Output: TStream);
var
  Status: Integer;
  CbBlockLen, CbPlainText: DWORD;
  CbKeyObject, CbData, CbCipherText: DWORD;
  PlainText, CipherText: Pointer;
  PlaintextData: TBytes;
begin
  CbBlockLen := 0;
  CbCipherText := 0;
  PlainText := nil;

  SetLength(PlaintextData, Input.Size);
  Input.Position := 0;
  Input.Read(PlaintextData, Input.Size);

  try
    CreateSymmetricKey(CbKeyObject, CbBlockLen);
    CreateIV(FIV, CbBlockLen);

    CbPlainText := Length(PlaintextData);
    PlainText := HeapAlloc(GetProcessHeap, 0, CbPlainText);
    if not Assigned(PlainText) then
      raise Exception.Create('Memory allocation failed');
    ArrayMove(PlaintextData, TBytes(PlainText));

    // Get the output buffer size.
    Status := BCryptEncrypt(FHAesKey,
                            PlainText,
                            CbPlainText,
                            nil,
                            FIVObject,
                            CbBlockLen,
                            nil,
                            0,
                            CbCipherText,
                            BCRYPT_BLOCK_PADDING);
    if not Succeeded(Status) then
      raise Exception.Create('BCryptEncrypt error: ' + IntToStr(Status));

    CipherText := HeapAlloc(GetProcessHeap, 0, CbCipherText);
    if not Assigned(CipherText) then
      raise Exception.Create('Memory allocation failed');

    // Use the key to encrypt the plaintext buffer.
    // For block sized messages, block padding will add an extra block.
    Status := BCryptEncrypt(FHAesKey,
                            PlainText,
                            CbPlainText,
                            nil,
                            FIVObject,
                            CbBlockLen,
                            CipherText,
                            CbCipherText,
                            CbData,
                            BCRYPT_BLOCK_PADDING);
    if not Succeeded(Status) then
      raise Exception.Create('BCryptEncrypt error: ' + IntToStr(Status));

    Output.Position := 0;
    Output.Write(FIV, CbBlockLen);
    Output.Write(TBytes(CipherText), CbCipherText);
  finally
    if Assigned(PlainText) then
      HeapFree(GetProcessHeap, 0, PlainText);
    ReleaseResources;
  end;
end;

procedure TCNGCrypt.ReleaseResources;
begin
  if Assigned(FHAesAlg) then
  begin
    BCryptCloseAlgorithmProvider(FHAesAlg, 0);
    FHAesAlg := nil;
  end;
  if Assigned(FHAesKey) then
  begin
    BCryptDestroyKey(FHAesKey);
    FHAesKey := nil;
  end;
  if Assigned(FIVObject) then
  begin
    HeapFree(GetProcessHeap, 0, FIVObject);
    FIVObject := nil;
  end;
  if Assigned(FKeyObject) then
  begin
    HeapFree(GetProcessHeap, 0, FKeyObject);
    FKeyObject := nil;
  end;
end;

end.

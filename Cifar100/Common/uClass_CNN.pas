Unit uClass_CNN;

Interface

{$O+}


Uses Windows,
  Messages,
  // SysUtils,
  System.SysUtils,
  Classes,
  Math,
  Dialogs,
  Inifiles,

  uClasses_Types,
  uFunctions;

Const
  c_Undefined = 0;

Type

  TTrainer = Class;

  TPredict = Class
    sLabelText: String;
    iPosition: Integer;
    iLabel: Integer;
    sLikeliHood: Double;
  End;

  TLearningInfo = Record
    StartTraining: TDatetime;
    TrainingDuration: Int64;
    iIterations: Integer;
    ActAcc: Double;
    ActLoss: Double;
  End;

  { ============================================================================= }
  TResponse = Class
    ptrFilter: TMyArray;
    ptrFilterGrads: TMyArray;
    l2_decay_mul: Double;
    l1_decay_mul: Double;
    Destructor destroy; override;
  End;

  TLayer = Class
    in_act: TVolume;
    out_act: TVolume;

    out_depth: Integer;
    out_sx: Integer;
    out_sy: Integer;
    layer_type: String;
    sName: String;

    fwTime: Int64;
    bwTime: Int64;

    Constructor create(opt: TOpt); virtual; abstract;
    Destructor destroy; virtual;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume;
      virtual; abstract;
    Function backward: Double; virtual; abstract;
    Function backwardLoss(y: Integer): Double; virtual; abstract;
    Function backwardOutput(y: TMyArray): Double; virtual; abstract;
    Function getParamsAndGrads: TList; virtual; abstract; // TResponse
  End;

  { ============================================================================= }
  TFW_Index = Record
    idx1: smallint;
    idx2: smallint;
    d: byte;
    ax: byte;
    ay: byte;
    bFin: Boolean;

  End;

  // pFW_Index = array [0 .. 2000000] of TFW_Index;

  TConvLayer = Class(TLayer)
  private
  public
    opt: TOpt;

    filters: TFilter; // TList<TVolume>;
    biases: TVolume;

    Filter_sx: Integer;
    Filter_sy: Integer;
    stride: Integer;
    pad: Integer;

    num_inputs: Integer;
    in_depth: Integer;
    in_sx: Integer;
    in_sy: Integer;

    l1_decay_mul: Double;
    l2_decay_mul: Double;
    bias: Double;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override; //
  End;

  { ============================================================================= }
  TFullyConnLayer = Class(TLayer)
    opt: TOpt;

    filters: TFilter;
    biases: TVolume;

    sx: Integer;
    sy: Integer;

    num_inputs: Integer;
    num_neurons: Integer;

    in_depth: Integer;
    in_sx: Integer;
    in_sy: Integer;

    l1_decay_mul: Double;
    l2_decay_mul: Double;
    bias: Double;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TPoolLayer = Class(TLayer)
    opt: TOpt;

    sx: Integer;
    sy: Integer;
    stride: Integer;
    pad: Integer;

    num_inputs: Integer;

    in_depth: Integer;
    in_sx: Integer;
    in_sy: Integer;

    switchx: TMyArray;
    switchy: TMyArray;

    l1_decay_mul: Double;
    l2_decay_mul: Double;
    bias: Double;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TInputLayer = Class(TLayer)
    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TSoftmaxLayer = Class(TLayer)
    es: TMyArray;
    num_inputs: Integer;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backwardLoss(y: Integer = 0): Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TSVMLayer = Class(TLayer)
    es: TMyArray;
    num_inputs: Integer;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backwardLoss(y: Integer): Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TRegressionLayer = Class(TLayer)
    es: TMyArray;

    num_inputs: Integer;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backwardLoss(y: Integer): Double; override;
    Function backwardOutput(y: TMyArray): Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TReluLayer = Class(TLayer)
    es: TMyArray;

    num_inputs: Integer;
    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TSigmoidLayer = Class(TLayer)
    es: TMyArray;
    num_inputs: Integer;
    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TMaxoutLayer = Class(TLayer)
    switches: TMyArray;
    num_inputs: Integer;
    group_size: Integer;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TTanhLayer = Class(TLayer)
    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }
  TDropoutLayer = Class(TLayer)

    drop_prob: Double;
    dropped: TMyArray;

    Constructor create(opt: TOpt);
    Destructor destroy; override;

    Function forward(Var v: TVolume; is_training: Boolean): TVolume; override;
    Function backward: Double; override;
    Function getParamsAndGrads: TList; override;
  End;

  { ============================================================================= }

  TNet = Class
    Layers: TList; // <TLayer>;
    sWightsFilename: String;

    Constructor create;
    Destructor destroy; override;

    Procedure makeLayers(Defs: TList); // <TOpt>);

    Function forward(Var volInput: TVolume; is_training: Boolean): TVolume;
    Function getCostLoss(volInput: TVolume; arrOut: TMyArray): Double;
    Function getParamsAndGrads: TList;
    Function backward(arrOut: TMyArray): Double;
    Function getPrediction(iBestAmount: Integer): TList; overload;
    Function getPrediction: Integer; overload;

    Procedure Export;
    Procedure Import;

    Procedure CSVExport(sFilename: String; Trainer: TTrainer;
      LearningInfo: TLearningInfo);
    Procedure CSVImport(sFilename: String; Trainer: TTrainer;
      Var LearningInfo: TLearningInfo);

  End;

  TTrainReg = Class
    fwd_time: Double;
    bwd_time: Double;
    l2_decay_loss: Double;
    l1_decay_loss: Double;
    cost_loss: Double;
    softmax_loss: Double;
    loss: Double;

    SumCostLoss: Double;
    Suml2decayloss: Double;
    TrainingAccuracy: Double;
    iRunStat: Integer;
    iRuns: Integer;

    AVGRunsPerSec: Integer;
    iStartTime: Integer;
  End;

  TTrainerOpt = Class
    method: String;

    // DER BATCH:
    // nach x Durchl�ufen wird der Lernalgorithmus angewendet und die Gewichte
    // angepasst. Bis dahin werden die Fehlersummen "gesammelt".
    batch_size: Integer; // nach jedem Batch werden die Gradienten gel�scht!

    // DER CHUNK
    // ein Block an Infomationen, der sicher gelernt sein muss, bevor der n�chste Chunk gelernt werden kann
    // wird eine Information nicht gelernt, so kommt sie in den n�chsten Chank zu wiederholten Lernen

    ChunkEnabled: Boolean; // das Chunk-Lernen einschalten
    ChunkSize: Integer;
    ChunkRepetitions: Integer;
    // Anzahl, wie oft ein Chunk wiederholt werden soll
    ChunkAccLikeliHood: Double;
    // Grenze f�r W-keit, dass eine Information nach einem Chunk-Durchlauf als gelernt akzeptiert wird
    ChunkNonAccLikeliHood: Double;
    // Grenze f�r W-keit, dass eine Information nach einem Chunk-Durchlauf als NICHT gelernt akzeptiert wird

    // die Lernparameter
    learning_rate: Double;
    l1_decay: Double;
    l2_decay: Double;
    momentum: Double;
    ro: Double;
    eps: Double;

  End;

  TTrainer = Class
    iFrameCounterForBatch: Integer;
    net: TNet;
    options: TTrainerOpt;

    gsum: TList; // <TMyArray>;
    xsum: TList; // <TMyArray>;

    beta1: Double; // ADAM
    beta2: Double; // ADAM

    TrainReg: TTrainReg;

    Constructor create(_net: TNet; _options: TTrainerOpt);
    Destructor destroy; override;
    Function train(Var volInput: TVolume; Var arrOut: TMyArray): TTrainReg;
  End;

  { ============================================================================= }
  TTrainData_Element = Class
    InData: TVolume;
    OutData: TMyArray;

    Constructor create(_sx, _sy, _depth: Integer; _OutVectorLen: Integer);
    Destructor destroy; override;

  End;

  TTrainData = Class(TList) // <TTrainData_Element>)

    sx, sy, depth: Integer;
    OutVectorLen: Integer;

    Constructor create(_sx, _sy, _depth: Integer; _OutVectorLen: Integer);
    Destructor destroy; override;

    Procedure AddTestData_1D(InValues: Array Of Double;
      OutValues: Array Of Double);
  End;

Implementation

// ==============================================================================
// Zusatzfunktionen
// ==============================================================================

{ ===============================================================================
  ===============================================================================
  ConvLayer
  ===============================================================================
  =============================================================================== }
// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Constructor TConvLayer.create(opt: TOpt);
Var
  i: Integer;
  xy_stride: Integer;
  d, ay, ax, fx, fy, fd: Integer; // Laufvariablen
Begin
  in_act := NIL;
  out_act := NIL;

  out_depth := opt.filters;
  Filter_sx := opt.Filter_sx;
  in_depth := opt.in_depth;
  in_sx := opt.in_sx;
  in_sy := opt.in_sy;

  If opt.Filter_sy = c_Undefined Then
    Filter_sy := opt.Filter_sx
  Else
    Filter_sy := opt.Filter_sy;

  If opt.stride <= 0 Then
    stride := 1
  Else
    stride := opt.stride;

  If opt.pad = c_Undefined Then
    pad := 0
  Else
    pad := opt.pad;

  If opt.l1_decay_mul = c_Undefined Then
    l1_decay_mul := 1
  Else
    l1_decay_mul := opt.l1_decay_mul;

  If opt.l2_decay_mul = c_Undefined Then
    l2_decay_mul := 1
  Else
    l2_decay_mul := opt.l2_decay_mul;

  out_sx := Math.floor((in_sx + pad * 2 - Filter_sx) / stride + 1);
  out_sy := Math.floor((in_sy + pad * 2 - Filter_sy) / stride + 1);
  layer_type := 'conv';

  If opt.bias_pref = c_Undefined Then
    bias := 0
  Else
    bias := opt.bias_pref;

  out_act := TVolume.create(out_sx, out_sy, out_depth);
  filters := TFilter.create(out_depth);

  // Filter erzeugen
  For i := 0 To out_depth - 1 Do
    filters.Buffer^[i] := TVolume.create(Filter_sx, Filter_sy, in_depth);

  biases := TVolume.create(1, 1, out_depth, bias);

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TConvLayer.destroy;
Var
  i: Integer;
Begin
  biases.Free;
  filters.Free;
  Inherited destroy;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TConvLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  V_sx: Integer;
  V_sy: Integer;
  x, y: Integer;
  f: TVolume;
  xy_stride: Integer;
  d, ay, ax, fx, fy, fd: Integer; // Laufvariablen

  ox, oy: Integer;

  Sum: Double;
  sDebug: Double;

  fwB, vwB: ^TPArrayDouble;
  ix11: Integer;
  ix22: Integer;
  fsxfy: Integer;
  V_sxoy: Integer;
  i: Integer;
  ix1, ix2: Integer;
  LastD: byte;
  LFW_Index: TFW_Index;
Begin
  in_act := v;

  xy_stride := stride;
  in_act := v;
  V_sx := v.sx;
  V_sy := v.sy;

  vwB := Pointer(v.w.Buffer);

  For d := 0 To out_depth - 1 Do
  Begin // over all filters
    f := filters.Buffer^[d];
    fwB := Pointer(f.w.Buffer);

    x := -pad;
    y := -pad;

    // move filter over
    For ay := 0 To out_sy - 1 Do
    Begin
      x := -pad;

      For ax := 0 To out_sx - 1 Do
      Begin

        // convolve centered at this particular location
        Sum := 0.0;
        For fy := 0 To f.sy - 1 Do
        Begin
          oy := y + fy; // coordinates in the original input array coordinates

          If (oy >= 0) And (oy < V_sy) Then
          Begin
            fsxfy := (f.sx * fy);
            V_sxoy := (V_sx * oy);
            For fx := 0 To f.sx - 1 Do
            Begin
              ox := x + fx;
              If (ox >= 0) And (ox < V_sx) Then
              Begin
                ix11 := (fsxfy + fx) * f.depth;
                ix22 := (V_sxoy + ox) * v.depth;

                For fd := 0 To f.depth - 1 Do
                Begin
                  Sum := Sum + fwB^[ix11 + fd] * vwB^[ix22 + fd];
                End
              End
            End;
          End
        End;
        Sum := Sum + TPArrayDouble(biases.w.Buffer^)[d];

        TPArrayDouble(out_act.w.Buffer^)
          [(out_act.sx * ay + ax) * out_act.depth + d] := Sum;

        inc(x, xy_stride);
      End;

      inc(y, xy_stride);
    End;
  End;

  result := out_act;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TConvLayer.backward: Double;
Var
  v: TVolume;
  V_sx: Integer;
  V_sy: Integer;
  x, y: Integer;
  f: TVolume;
  xy_stride: Integer;
  d, ay, ax, fx, fy, fd: Integer; // Laufvariablen

  ox, oy: Integer;

  Sum: Double;
  ix1, ix2: Integer;
  chain_grad: Double;
  i: Integer;

  fdwB, vdwB: ^TPArrayDouble;
  fwB, vwB, bdb: ^TPArrayDouble;
  ix11: Integer;
  ix22: Integer;
  V_sxoy: Integer;
  fsxfy: Integer;
Begin

  v := in_act;
  v.dw.FillZero;

  vdwB := Pointer(v.dw.Buffer);
  vwB := Pointer(v.w.Buffer);
  bdb := Pointer(biases.dw.Buffer);

  V_sx := v.sx;
  V_sy := v.sy;
  xy_stride := stride;

  For d := 0 To out_depth - 1 Do
  Begin

    f := filters.Buffer^[d];
    fdwB := Pointer(f.dw.Buffer);
    fwB := Pointer(f.w.Buffer);

    x := -pad;
    y := -pad;
    For ay := 0 To out_sy - 1 Do // xy_stride
    Begin

      x := -pad;
      For ax := 0 To out_sx - 1 Do // xy_stride
      Begin

        // convolve centered at this particular location
        chain_grad := out_act.get_grad(ax, ay, d);
        // gradient from above, from chain rule
        For fy := 0 To f.sy - 1 Do
        Begin
          oy := y + fy; // coordinates in the original input array coordinates

          If (oy >= 0) And (oy < V_sy) Then
          Begin
            V_sxoy := (V_sx * oy);
            fsxfy := (f.sx * fy);
            For fx := 0 To f.sx - 1 Do
            Begin
              ox := x + fx;
              If (ox >= 0) And (ox < V_sx) Then
              Begin
                ix11 := (V_sxoy + ox) * v.depth;
                ix22 := (fsxfy + fx) * f.depth;

                For fd := 0 To f.depth - 1 Do
                Begin
                  ix1 := ix11 + fd;
                  ix2 := ix22 + fd;
                  fdwB^[ix2] := fdwB^[ix2] + vwB^[ix1] * chain_grad;
                  vdwB^[ix1] := vdwB^[ix1] + fwB^[ix2] * chain_grad;
                End;
              End;
            End;
          End;
        End;

        bdb^[d] := bdb^[d] + chain_grad; // BIAS

        inc(x, xy_stride);
      End;
      inc(y, xy_stride);
    End;
  End;

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TConvLayer.getParamsAndGrads: TList;
Var
  i: Integer;
  resp: TResponse;
Begin
  result := TList.create;
  For i := 0 To out_depth - 1 Do
  Begin
    resp := TResponse.create;
    resp.ptrFilter := filters.Buffer^[i].w;
    resp.ptrFilterGrads := filters.Buffer^[i].dw;
    resp.l2_decay_mul := l2_decay_mul;
    resp.l1_decay_mul := l1_decay_mul;

    result.Add(resp);
  End;

  // Bias
  resp := TResponse.create;
  resp.ptrFilter := biases.w;
  resp.ptrFilterGrads := biases.dw;
  resp.l2_decay_mul := 0;
  resp.l1_decay_mul := 0;
  result.Add(resp);
End;

{ ===============================================================================
  ===============================================================================
  FullyConnLayer
  ===============================================================================
  =============================================================================== }

Constructor TFullyConnLayer.create(opt: TOpt);
Var
  i: Integer;
Begin
  in_act := NIL;
  out_act := NIL;

  Inherited;
  out_depth := opt.filters;

  num_neurons := opt.num_neurons;

  If opt.num_neurons = c_Undefined Then
    out_depth := opt.filters
  Else
    out_depth := opt.num_neurons;

  If opt.l1_decay_mul = c_Undefined Then
    l1_decay_mul := 0
  Else
    l1_decay_mul := opt.l1_decay_mul;

  If opt.l2_decay_mul = c_Undefined Then
    l2_decay_mul := 1
  Else
    l2_decay_mul := opt.l2_decay_mul;

  num_inputs := opt.in_sx * opt.in_sy * opt.in_depth;
  out_sx := 1;
  out_sy := 1;

  layer_type := 'fc';

  If opt.bias_pref = c_Undefined Then
    bias := 0
  Else
    bias := opt.bias_pref;

  out_act := TVolume.create(1, 1, out_depth, 0);

  // filters := TList<TVolume>.create;
  filters := TFilter.create(out_depth);
  For i := 0 To out_depth - 1 Do
    filters.Buffer^[i] := TVolume.create(1, 1, num_inputs);

  biases := TVolume.create(1, 1, out_depth, bias);

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TFullyConnLayer.destroy;
Var
  i: Integer;
Begin
  If assigned(biases) Then
    freeandnil(biases);
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TFullyConnLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  VW, WI: TMyArray;
  i, d: Integer; // Laufvariablen
  Sum: Double;
  sDebug: Double;
Begin

  in_act := v;

  out_act.w.FillZero;
  // a.dw.FillZero;

  VW := v.w;

  // �ber alle Filter
  For i := 0 To out_depth - 1 Do
  Begin
    Sum := 0;
    WI := filters.Buffer^[i].w;

    // summiere:  Eing�nge * Gewichte
    If WI.length = 0 Then
      For d := 0 To num_inputs - 1 Do
      Begin
        Sum := Sum + TPArrayDouble(VW.Buffer^)[d]; //
      End
    Else
      For d := 0 To num_inputs - 1 Do
      Begin
        sDebug := TPArrayDouble(VW.Buffer^)[d];
        Sum := Sum + TPArrayDouble(VW.Buffer^)[d] *
          TPArrayDouble(WI.Buffer^)[d];
      End;

    // summiere den Bias noch hinzu
    Sum := Sum + TPArrayDouble(biases.w.Buffer^)[i];

    // das
    TPArrayDouble(out_act.w.Buffer^)[i] := Sum;
  End;

  result := out_act;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TFullyConnLayer.backward: Double;
Var
  v, tfi: TVolume;
  i, d: Integer; // Laufvariablen
  chain_grad: Double;
Begin
  v := in_act;
  v.dw.FillZero;

  // compute gradient wrt weights and data
  For i := 0 To out_depth - 1 Do
  Begin
    tfi := filters.Buffer^[i];
    chain_grad := TPArrayDouble(out_act.dw.Buffer^)[i];
    For d := 0 To num_inputs - 1 Do
    Begin

      TPArrayDouble(v.dw.Buffer^)[d] := TPArrayDouble(v.dw.Buffer^)[d] +
        TPArrayDouble(tfi.w.Buffer^)[d] * chain_grad; // grad wrt input data
      TPArrayDouble(tfi.dw.Buffer^)[d] := TPArrayDouble(tfi.dw.Buffer^)[d] +
        TPArrayDouble(v.w.Buffer^)[d] * chain_grad; // grad wrt params
    End;
    TPArrayDouble(biases.dw.Buffer^)[i] := TPArrayDouble(biases.dw.Buffer^)[i] +
      chain_grad;
  End;

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TFullyConnLayer.getParamsAndGrads: TList;
Var
  i, j: Integer;
  resp: TResponse;
Begin
  result := TList.create;
  For i := 0 To out_depth - 1 Do
  Begin
    resp := TResponse.create;

    resp.ptrFilter := filters.Buffer^[i].w;
    // hier stecken die Filter, die sp�ter angepasst werden
    resp.ptrFilterGrads := filters.Buffer^[i].dw;

    resp.l2_decay_mul := l2_decay_mul;
    resp.l1_decay_mul := l1_decay_mul;

    result.Add(resp);
  End;

  // Bias
  resp := TResponse.create;
  resp.ptrFilter := biases.w;
  resp.ptrFilterGrads := biases.dw;
  resp.l2_decay_mul := 0;
  resp.l1_decay_mul := 0;
  result.Add(resp);
End;

{ ===============================================================================
  ===============================================================================
  PoolLayer
  ===============================================================================
  =============================================================================== }

Constructor TPoolLayer.create(opt: TOpt);
Var
  i: Integer;
Begin
  in_act := NIL;
  out_act := NIL;

  out_depth := opt.filters;
  sx := opt.Filter_sx;
  in_depth := opt.in_depth;
  in_sx := opt.in_sx;
  in_sy := opt.in_sy;

  If opt.Filter_sy = c_Undefined Then
    sy := opt.Filter_sx
  Else
    sy := opt.Filter_sy;

  If opt.stride = c_Undefined Then
    stride := 1
  Else
    stride := opt.stride;

  If opt.pad = c_Undefined Then
    pad := 0
  Else
    pad := opt.pad;

  out_depth := in_depth;
  out_sx := Math.floor((in_sx + pad * 2 - sx) / stride + 1);
  out_sy := Math.floor((in_sy + pad * 2 - sy) / stride + 1);
  layer_type := 'pool';
  // store switches for x,y coordinates for where the max comes from, for each output neuron

  switchx := Global.Zeros(out_sx * out_sy * out_depth);
  switchy := Global.Zeros(out_sx * out_sy * out_depth);

  out_act := TVolume.create(out_sx, out_sy, out_depth, 0.0);

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TPoolLayer.destroy;
Begin
  freeandnil(switchx);
  freeandnil(switchy);

  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TPoolLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  V_sx: Integer;
  V_sy: Integer;
  x, y: Integer;
  f: TVolume;
  xy_stride: Integer;
  d, ay, ax, fx, fy, fd: Integer; // Laufvariablen

  ox, oy: Integer;
  n, winx, winy: Integer;
  Sum, Value, sDebug: Double;
Begin
  // optimized code by @mdda that achieves 2x speedup over previous version

  in_act := v;
  out_act.w.FillZero;
  // a.dw.FillZero;

  n := 0; // a counter for switches
  For d := 0 To out_depth - 1 Do
  Begin
    x := -pad;

    For ax := 0 To out_sx - 1 Do
    Begin

      y := -pad;
      For ay := 0 To out_sy - 1 Do
      Begin

        // convolve centered at this particular location
        Sum := -999999999999; // hopefully small enough ;\
        winx := -1;
        winy := -1;
        For fx := 0 To sx - 1 Do
        Begin
          For fy := 0 To sy - 1 Do
          Begin
            oy := y + fy;
            ox := x + fx;
            If (oy >= 0) And (oy < v.sy) And (ox >= 0) And (ox < v.sx) Then
            Begin
              Value := v.get(ox, oy, d);
              // perform max pooling and store pointers to where
              // the max came from. This will speed up backprop
              // and can help make nice visualizations in future
              If (Value > Sum) Then
              Begin
                Sum := Value;
                winx := ox;
                winy := oy;
              End;
            End
            Else
            Begin
              sDebug := v.get(ox, oy, d);
            End;
          End;

        End;
        TPArrayDouble(switchx.Buffer^)[n] := winx;
        TPArrayDouble(switchy.Buffer^)[n] := winy;
        n := n + 1;
        out_act.setVal(ax, ay, d, Sum);
        y := y + stride;
      End;
      x := x + stride;
    End;
  End;

  result := out_act;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TPoolLayer.backward: Double;
Var
  v: TVolume;
  V_sx: Integer;
  V_sy: Integer;
  x, y: Integer;
  f: TVolume;
  xy_stride: Integer;
  i, d, ay, ax, fx, fy, fd: Integer; // Laufvariablen

  ox, oy: Integer;

  Sum: Double;
  n: Integer;
  chain_grad: Double;
Begin

  v := in_act;
  v.dw.FillZero;

  n := 0;
  For d := 0 To out_depth - 1 Do
  Begin
    x := -pad;
    y := -pad;
    For ax := 0 To out_sx - 1 Do
    Begin

      y := -pad;
      For ay := 0 To out_sy - 1 Do
      Begin
        chain_grad := out_act.get_grad(ax, ay, d);
        v.add_grad(round(TPArrayDouble(switchx.Buffer^)[n]),
          round(TPArrayDouble(switchy.Buffer^)[n]), d, chain_grad);
        n := n + 1;

        y := y + stride;
      End;

      x := x + stride;
    End
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TPoolLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  InputLayer
  ===============================================================================
  =============================================================================== }

Constructor TInputLayer.create(opt: TOpt);
Var
  i: Integer;
Begin
  in_act := NIL;
  out_act := NIL;

  If opt.out_depth <> c_Undefined Then
    out_depth := opt.out_depth
  Else If opt.depth <> c_Undefined Then
    out_depth := opt.depth
  Else
    out_depth := 0;

  If opt.out_sx <> c_Undefined Then
    out_sx := opt.out_sx
  Else If opt.Filter_sx <> c_Undefined Then
    out_sx := opt.Filter_sx
  Else If opt.width <> c_Undefined Then
    out_sx := opt.width
  Else
    out_sx := 1;

  If opt.out_sy <> c_Undefined Then
    out_sy := opt.out_sy
  Else If opt.Filter_sy <> c_Undefined Then
    out_sy := opt.Filter_sy
  Else If opt.height <> c_Undefined Then
    out_sy := opt.height
  Else
    out_sy := 1;
  layer_type := 'input';

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TInputLayer.destroy;
Begin
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TInputLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Begin
  in_act := v;
  out_act := v;
  result := out_act; // simply identity function for now
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TInputLayer.backward: Double;
Begin

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TInputLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  SoftmaxLayer
  // Layers that implement a loss. Currently these are the layers that
  // can initiate a backward() pass. In future we probably want a more
  // flexible system that can accomodate multiple losses to do multi-task
  // learning, and stuff like that. But for now, one of the layers in this
  // file must be the final layer in a Net.

  // This is a classifier, with N discrete classes from 0 to N-1
  // it gets a stream of N incoming numbers and computes the softmax
  // function (exponentiate and normalize to sum to 1 as probabilities should)
  ===============================================================================
  =============================================================================== }

Constructor TSoftmaxLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;

  num_inputs := opt.in_sx * opt.in_sy * opt.in_depth;
  out_depth := num_inputs;
  out_sx := 1;
  out_sy := 1;
  layer_type := 'softmax';

  out_act := TVolume.create(1, 1, out_depth, 0);
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TSoftmaxLayer.destroy;
Begin
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSoftmaxLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  i: Integer;
  amax, eSum, e: Double;
  _as, _es: TMyArray;
Begin
  in_act := v;

  out_act.w.FillZero;
  // a.dw.FillZero;

  // compute max activation
  _as := v.w;
  amax := TPArrayDouble(v.w.Buffer^)[0];
  For i := 1 To out_depth - 1 Do
    If (TPArrayDouble(_as.Buffer^)[i] > amax) Then
      amax := TPArrayDouble(_as.Buffer^)[i];

  // compute exponentials (carefully to not blow up)

  If es <> Nil Then
  Begin
    _es := es;
    _es.FillZero;
  End
  Else
    _es := Global.Zeros(out_depth);

  eSum := 0.0;
  For i := 0 To out_depth - 1 Do
  Begin
    e := exp(TPArrayDouble(_as.Buffer^)[i] - amax);
    eSum := eSum + e;
    TPArrayDouble(_es.Buffer^)[i] := e;
  End;

  // normalize and output to sum to one
  For i := 0 To out_depth - 1 Do
  Begin
    TPArrayDouble(_es.Buffer^)[i] := TPArrayDouble(_es.Buffer^)[i] / eSum;
    TPArrayDouble(out_act.w.Buffer^)[i] := TPArrayDouble(_es.Buffer^)[i];
  End;

  es := _es; // save these for backprop

  result := out_act;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSoftmaxLayer.backwardLoss(y: Integer = 0): Double;
Var
  x: TVolume;
  i, indicator: Integer;
  mul: Double;
Begin
  x := in_act;
  x.dw.FillZero;

  For i := 0 To out_depth - 1 Do
  Begin
    If i = y Then
      indicator := 1
    Else
      indicator := 0;

    mul := -(indicator - TPArrayDouble(es.Buffer^)[i]);
    TPArrayDouble(x.dw.Buffer^)[i] := mul;
  End;

  // loss is the class negative log likelihood
  If TPArrayDouble(es.Buffer^)[y] > 0 Then
    result := -Math.Log10(TPArrayDouble(es.Buffer^)[y])
  Else
    result := 0;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSoftmaxLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  RegressionLayer
  // implements an L2 regression cost layer,
  // so penalizes \sum_i(||x_i - y_i||^2), where x is its input
  // and y is the user-provided array of "correct" values.
  ===============================================================================
  =============================================================================== }

Constructor TRegressionLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;
  num_inputs := opt.in_sx * opt.in_sy * opt.in_depth;
  out_depth := num_inputs;
  out_sx := 1;
  out_sy := 1;
  layer_type := 'regression';
End;

Destructor TRegressionLayer.destroy;
Begin
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TRegressionLayer.forward(Var v: TVolume; is_training: Boolean)
  : TVolume;
Begin
  in_act := v;
  out_act := v;
  result := v; // identity function
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TRegressionLayer.backwardOutput(y: TMyArray): Double;
Var
  x: TVolume;
  i, indicator: Integer;
  mul, loss, dy: Double;
Begin
  x := in_act;
  x.dw.FillZero;
  loss := 0.0;
  For i := 0 To out_depth - 1 Do
  Begin
    dy := TPArrayDouble(x.w.Buffer^)[i] - TPArrayDouble(y.Buffer^)[i];
    TPArrayDouble(x.dw.Buffer^)[i] := dy;
    loss := loss + 0.5 * dy * dy;
  End;

  result := loss;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TRegressionLayer.backwardLoss(y: Integer): Double;
Var
  x: TVolume;
  i, indicator: Integer;
  mul, loss, dy: Double;
Begin
  x := in_act;
  x.dw.FillZero;
  loss := 0.0;

  // lets hope that only one number is being regressed
  dy := TPArrayDouble(x.w.Buffer^)[0] - y;
  TPArrayDouble(x.dw.Buffer^)[0] := dy;
  loss := loss + 0.5 * dy * dy;

  result := loss;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TRegressionLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  SVMLayer
  ===============================================================================
  =============================================================================== }

Constructor TSVMLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;
  num_inputs := opt.in_sx * opt.in_sy * opt.in_depth;
  out_depth := num_inputs;
  out_sx := 1;
  out_sy := 1;
  layer_type := 'svm';
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TSVMLayer.destroy;
Begin
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSVMLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Begin
  in_act := v;
  out_act := v;
  result := v; // identity function
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSVMLayer.backwardLoss(y: Integer): Double;
Var
  x: TVolume;
  i, indicator: Integer;
  mul, loss, dy, yscore, margin, ydiff: Double;
Begin
  // compute and accumulate gradient wrt weights and bias of this layer
  x := in_act;
  x.dw.FillZero;;

  // we're using structured loss here, which means that the score
  // of the ground truth should be higher than the score of any other
  // class, by a margin
  yscore := TPArrayDouble(x.w.Buffer^)[y]; // score of ground truth
  margin := 1.0;
  loss := 0.0;
  For i := 0 To out_depth - 1 Do
  Begin
    If (y = i) Then
      continue;

    ydiff := -yscore + TPArrayDouble(x.w.Buffer^)[i] + margin;
    If (ydiff > 0) Then
    Begin
      // violating dimension, apply loss
      TPArrayDouble(x.dw.Buffer^)[i] := TPArrayDouble(x.dw.Buffer^)[i] + 1;
      TPArrayDouble(x.dw.Buffer^)[y] := TPArrayDouble(x.dw.Buffer^)[y] - 1;
      loss := loss + ydiff;
    End
  End;

  result := loss;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSVMLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  ReluLayer

  // Implements ReLU nonlinearity elementwise
  // x -> max(0, x)
  // the output is in [0, inf)
  ===============================================================================
  =============================================================================== }

Constructor TReluLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;

  out_sx := opt.in_sx;
  out_sy := opt.in_sy;
  out_depth := opt.in_depth;
  layer_type := 'relu';
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TReluLayer.destroy;
Begin
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TReluLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  V2: TVolume;
  n: Integer;
  i: Integer;
  sDebug: Double;
Begin
  in_act := v;
  If out_act <> Nil Then
  Begin
    V2 := out_act;
    V2.Copy(v);
  End
  Else
    V2 := v.clone();

  For i := 0 To v.w.length - 1 Do
  Begin
    sDebug := TPArrayDouble(v.w.Buffer^)[i];

    If (TPArrayDouble(v.w.Buffer^)[i] < 0) Then
      TPArrayDouble(V2.w.Buffer^)[i] := 0 // threshold at 0
    Else
      TPArrayDouble(V2.w.Buffer^)[i] := TPArrayDouble(v.w.Buffer^)[i];
  End;

  out_act := V2;
  result := out_act;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TReluLayer.backward: Double;
Var
  v, V2: TVolume;
  n, i: Integer;
Begin
  v := in_act; // we need to set dw of this
  V2 := out_act;
  n := v.w.length;
  // v.dw.FillZero;

  For i := 0 To n - 1 Do
  Begin
    If (TPArrayDouble(V2.w.Buffer^)[i] <= 0) Then
      TPArrayDouble(v.dw.Buffer^)[i] := 0 // threshold
    Else
      TPArrayDouble(v.dw.Buffer^)[i] := TPArrayDouble(V2.dw.Buffer^)[i];
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TReluLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  SigmoidLayer

  // Implements Sigmoid nnonlinearity elementwise
  // x -> 1/(1+e^(-x))
  // so the output is between 0 and 1.
  ===============================================================================
  =============================================================================== }

Constructor TSigmoidLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;
  out_sx := opt.in_sx;
  out_sy := opt.in_sy;
  out_depth := opt.in_depth;
  layer_type := 'sigmoid';
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TSigmoidLayer.destroy;
Begin
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSigmoidLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  V2: TVolume;
  n: Integer;
  V2w, VW: TMyArray;
  i: Integer;
Begin

  in_act := v;

  If out_act <> Nil Then
  Begin
    V2 := out_act;
    // V2.Copy(v);
  End
  Else
    V2 := v.cloneAndZero();

  n := v.w.length;
  V2w := V2.w;
  VW := v.w;
  For i := 0 To n - 1 Do
  Begin
    TPArrayDouble(V2w.Buffer^)[i] := 1.0 /
      (1.0 + exp(-TPArrayDouble(VW.Buffer^)[i]));
  End;

  out_act := V2;
  result := out_act;

End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSigmoidLayer.backward: Double;
Var
  v, V2: TVolume;
  n: Integer;
  v2wi: Double;
  i: Integer;
Begin
  v := in_act; // we need to set dw of this
  V2 := out_act;
  n := v.w.length;
  // v.dw.FillZero;
  For i := 0 To n - 1 Do
  Begin
    v2wi := TPArrayDouble(V2.w.Buffer^)[i];
    TPArrayDouble(v.dw.Buffer^)[i] := v2wi * (1.0 - v2wi) *
      TPArrayDouble(V2.dw.Buffer^)[i];
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TSigmoidLayer.getParamsAndGrads: TList;
Begin
  result := Nil
End;
{ ===============================================================================
  ===============================================================================
  MaxoutLayer

  // Implements Maxout nnonlinearity that computes
  // x -> max(x)
  // where x is a vector of size group_size. Ideally of course,
  // the input size should be exactly divisible by group_size
  ===============================================================================
  =============================================================================== }

Constructor TMaxoutLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;
  If opt.group_size = c_Undefined Then
    group_size := 2
  Else
    group_size := opt.group_size;

  out_sx := opt.in_sx;
  out_sy := opt.in_sy;
  out_depth := Math.floor(opt.in_depth / group_size);
  layer_type := 'maxout';

  switches := Global.Zeros(out_sx * out_sy * out_depth); // useful for backprop
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TMaxoutLayer.destroy;
Begin
  switches.Free;
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TMaxoutLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  n, i, ix, j, x, y: Integer;
  V2: TVolume;
  a, a2: Double;
  ai: Double;
Begin

  in_act := v;
  n := out_depth;

  If out_act <> Nil Then
  Begin
    V2 := out_act;
    V2.Copy(v);
  End
  Else
    V2 := TVolume.create(out_sx, out_sy, out_depth, 0.0);

  // optimization branch. If we're operating on 1D arrays we dont have
  // to worry about keeping track of x,y,d coordinates inside
  // input volumes. In convnets we do :(
  If (out_sx = 1) And (out_sy = 1) Then
  Begin
    For i := 0 To n - 1 Do
    Begin
      ix := i * group_size; // base index offset
      a := TPArrayDouble(v.w.Buffer^)[ix];
      ai := 0;
      For j := 1 To group_size - 1 Do
      Begin
        a2 := TPArrayDouble(v.w.Buffer^)[ix + j];
        If (a2 > a) Then
        Begin
          a := a2;
          ai := j;
        End
      End;
      TPArrayDouble(V2.w.Buffer^)[i] := a;
      TPArrayDouble(switches.Buffer^)[i] := ix + ai;
    End
  End
  Else
  Begin
    n := 0; // counter for switches
    For x := 0 To v.sx - 1 Do
    Begin
      For y := 0 To v.sy - 1 Do
      Begin
        For i := 0 To n - 1 Do
        Begin
          ix := i * group_size;
          a := v.get(x, y, ix);
          ai := 0;
          For j := 1 To group_size - 1 Do
          Begin
            a2 := v.get(x, y, ix + j);
            If (a2 > a) Then
            Begin
              a := a2;
              ai := j;
            End
          End;
          V2.setVal(x, y, i, a);
          TPArrayDouble(switches.Buffer^)[n] := ix + ai;
          inc(n);
        End
      End
    End
  End;

  out_act := V2;
  result := out_act;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TMaxoutLayer.backward: Double;
Var
  v, V2: TVolume;
  n: Integer;
  chain_grad: Double;
  i, x, y: Integer;
Begin
  v := in_act; // we need to set dw of this
  V2 := out_act;
  n := out_depth;
  v.dw.FillZero;

  // pass the gradient through the appropriate switch
  If (out_sx = 1) And (out_sy = 1) Then
  Begin
    For i := 0 To n - 1 Do
    Begin
      chain_grad := TPArrayDouble(V2.dw.Buffer^)[i];
      TPArrayDouble(v.dw.Buffer^)[trunc(TPArrayDouble(switches.Buffer^)[i])] :=
        chain_grad;
    End
  End
  Else
  Begin
    // bleh okay, lets do this the hard way
    n := 0; // counter for switches
    For x := 0 To V2.sx - 1 Do
    Begin
      For y := 0 To V2.sy - 1 Do
      Begin
        For i := 0 To n - 1 Do
        Begin
          chain_grad := V2.get_grad(x, y, i);
          v.set_grad(x, y, trunc(TPArrayDouble(switches.Buffer^)[n]),
            chain_grad);
          inc(n);
        End
      End
    End
  End
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TMaxoutLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  TanhLayer

  // Implements Tanh nnonlinearity elementwise
  // x -> tanh(x)
  // so the output is between -1 and 1.
  ===============================================================================
  =============================================================================== }

Constructor TTanhLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;

  out_sx := opt.in_sx;
  out_sy := opt.in_sy;
  out_depth := opt.in_depth;
  layer_type := 'tanh';
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TTanhLayer.destroy;
Begin
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TTanhLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  V2: TVolume;
  n, i: Integer;
Begin

  in_act := v;
  If out_act <> Nil Then
  Begin
    V2 := out_act;
    V2.Copy(v);
  End
  Else
    V2 := v.cloneAndZero();

  n := v.w.length;
  For i := 0 To n - 1 Do
  Begin
    TPArrayDouble(V2.w.Buffer^)[i] := tanh(TPArrayDouble(v.w.Buffer^)[i]);
  End;

  out_act := V2;
  result := out_act;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TTanhLayer.backward: Double;
Var
  v, V2: TVolume;
  n, i: Integer;
  v2wi: Double;
Begin
  v := in_act; // we need to set dw of this
  V2 := out_act;
  n := v.w.length;
  v.dw.FillZero;;
  For i := 0 To n - 1 Do
  Begin
    v2wi := TPArrayDouble(V2.w.Buffer^)[i];
    TPArrayDouble(v.dw.Buffer^)[i] := (1.0 - v2wi * v2wi) *
      TPArrayDouble(V2.dw.Buffer^)[i];
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TTanhLayer.getParamsAndGrads: TList;
Begin
  result := Nil;
End;

{ ===============================================================================
  ===============================================================================
  DropoutLayer

  // An inefficient dropout layer
  // Note this is not most efficient implementation since the layer before
  // computed all these activations and now we're just going to drop them :(
  // same goes for backward pass. Also, if we wanted to be efficient at test time
  // we could equivalently be clever and upscale during train and copy pointers during test
  // todo: make more efficient.
  ===============================================================================
  =============================================================================== }

Constructor TDropoutLayer.create(opt: TOpt);
Begin
  in_act := NIL;
  out_act := NIL;
  out_sx := opt.in_sx;
  out_sy := opt.in_sy;
  out_depth := opt.in_depth;
  layer_type := 'dropout';

  If opt.drop_prob = c_Undefined Then
    drop_prob := 0.5
  Else
    drop_prob := opt.drop_prob;

  dropped := Global.Zeros(out_sx * out_sy * out_depth);
End;

Destructor TDropoutLayer.destroy;
Begin
  dropped.Free;
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TDropoutLayer.forward(Var v: TVolume; is_training: Boolean): TVolume;
Var
  V2: TVolume;
  n, i: Integer;
Begin

  in_act := v;
  If out_act <> Nil Then
  Begin
    V2 := out_act;
    V2.Copy(v);
  End
  Else
    V2 := v.clone();

  n := v.w.length;
  If (is_training) Then
  Begin
    // do dropout
    For i := 0 To n - 1 Do
    Begin
      If (random < drop_prob) Then
      Begin
        TPArrayDouble(V2.w.Buffer^)[i] := 0;
        TPArrayDouble(dropped.Buffer^)[i] := 1;
      End // drop!
      Else
        TPArrayDouble(dropped.Buffer^)[i] := 0;
    End
  End
  Else
  Begin
    // scale the activations during prediction
    For i := 0 To n - 1 Do
    Begin
      TPArrayDouble(V2.w.Buffer^)[i] := TPArrayDouble(V2.w.Buffer^)[i] *
        drop_prob;
    End
  End;

  out_act := V2;
  result := out_act; // dummy identity function for now
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TDropoutLayer.backward: Double;
Var
  v, V2: TVolume;
  n, i: Integer;
  chain_grad: TVolume;
Begin
  v := in_act; // we need to set dw of this
  chain_grad := out_act;
  n := v.w.length;
  v.dw.FillZero;;
  For i := 0 To i - 1 Do
  Begin
    If (TPArrayDouble(dropped.Buffer^)[i] = 0) Then
      TPArrayDouble(v.dw.Buffer^)[i] := TPArrayDouble(chain_grad.dw.Buffer^)[i];
    // copy over the gradient
  End
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TDropoutLayer.getParamsAndGrads: TList;
Begin
  result := Nil
End;

{ ===============================================================================
  ===============================================================================
  TNet
  ===============================================================================
  =============================================================================== }

Constructor TNet.create;
Begin
  Layers := TList.create; // <TLayer>
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TNet.destroy;
Var
  i: Integer;
Begin
  For i := 0 To Layers.Count - 1 Do
    TLayer(Layers[i]).Free;

  Layers.Clear;
  Layers.Free;
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 15.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Procedure TNet.CSVExport(sFilename: String; Trainer: TTrainer;
  LearningInfo: TLearningInfo);
Var
  iLayerIDX, iFilterIDX: Integer;
  s: TLayer;
  ListVolume: TList; // <TVolume>;
  vol: TVolume;
  k, d: Integer;

  f: TextFile;

  Procedure StoreLearningInfo;
  Begin
    writeln(f, '[LearningInfo]');
    writeln(f, 'StartTraining=' + DatetimeToStr(LearningInfo.StartTraining));
    writeln(f, 'TrainingDuration=' + inttostr(LearningInfo.TrainingDuration));
    writeln(f, 'iIterations=' + inttostr(LearningInfo.iIterations));
    writeln(f, 'ActAcc=' + Floattostr(LearningInfo.ActAcc));
    writeln(f, 'ActLoss=' + Floattostr(LearningInfo.ActLoss));
  End;

  Procedure StoreUserData;
  Begin
    writeln(f, '[Options]');
    writeln(f, 'method=' + Trainer.options.method);
    writeln(f, 'batch_size=' + inttostr(Trainer.options.batch_size));
    writeln(f, 'learning_rate=' + Floattostr(Trainer.options.learning_rate));
    writeln(f, 'momentum=' + Floattostr(Trainer.options.momentum));
    writeln(f, 'l1_decay=' + Floattostr(Trainer.options.l1_decay));
    writeln(f, 'l2_decay=' + Floattostr(Trainer.options.l2_decay));
    writeln(f, 'ro=' + Floattostr(Trainer.options.ro));
    writeln(f, 'eps=' + Floattostr(Trainer.options.eps));
    writeln(f, '');
  End;

  Procedure StoreStructure;
  Var
    iLayerIDX: Integer;
  Begin
    For iLayerIDX := 0 To Layers.Count - 1 Do
    Begin
      // Lade den Layer
      s := Layers[iLayerIDX];
      writeln(f, '[Layer_' + inttostr(iLayerIDX) + ']');
      writeln(f, 'Name=' + s.sName);
      writeln(f, 'Type=' + s.layer_type);
      writeln(f, 'out_depth=' + inttostr(s.out_depth));

      writeln(f, 'out_sx=' + inttostr(s.out_sx));
      writeln(f, 'out_sy=' + inttostr(s.out_sy));

      If s Is TConvLayer Then
      Begin
        writeln(f, 'sx=' + inttostr(TConvLayer(s).Filter_sx));
        writeln(f, 'Activation=' + TLayer(Layers[iLayerIDX + 1]).layer_type);
        writeln(f, 'Stride=' + inttostr(TConvLayer(s).stride));
        writeln(f, 'Pad=' + inttostr(TConvLayer(s).pad));
        writeln(f, 'Filters=' + inttostr(TConvLayer(s).filters.length));
        writeln(f, 'l1_decay_mul=' + Floattostr(TConvLayer(s).l1_decay_mul));
        writeln(f, 'l2_decay_mul=' + Floattostr(TConvLayer(s).l2_decay_mul));
      End;

      If s Is TPoolLayer Then
      Begin
        writeln(f, 'sx=' + inttostr(TPoolLayer(s).sx));
        writeln(f, 'Stride=' + inttostr(TPoolLayer(s).stride));
        writeln(f, 'Pad=' + inttostr(TPoolLayer(s).pad));
      End;
      If s Is TFullyConnLayer Then
      Begin
        writeln(f, 'num_neurons=' + inttostr(TFullyConnLayer(s).num_neurons));
      End;

      If s Is TSoftmaxLayer Then
      Begin
        writeln(f, 'num_inputs=' + inttostr(TSoftmaxLayer(s).num_inputs));
      End;

      If s Is TSVMLayer Then
      Begin
        writeln(f, 'num_inputs=' + inttostr(TSVMLayer(s).num_inputs));
      End;

      If s Is TRegressionLayer Then
      Begin
        writeln(f, 'num_inputs=' + inttostr(TRegressionLayer(s).num_inputs));
      End;
      If s Is TReluLayer Then
      Begin
        writeln(f, 'num_inputs=' + inttostr(TReluLayer(s).num_inputs));
      End;

      If s Is TSigmoidLayer Then
      Begin
        writeln(f, 'num_inputs=' + inttostr(TSigmoidLayer(s).num_inputs));
      End;

      If s Is TMaxoutLayer Then
      Begin
        writeln(f, 'num_inputs=' + inttostr(TMaxoutLayer(s).num_inputs));
        writeln(f, 'group_size=' + inttostr(TMaxoutLayer(s).group_size));
      End;

      If s Is TDropoutLayer Then
      Begin
        writeln(f, 'drop_prob=' + Floattostr(TDropoutLayer(s).drop_prob));
      End;

      writeln(f, '');
    End;
  End;

  Procedure StoreArray(aIn: TMyArray);
  Var
    i: Integer;
  Begin
    If aIn <> Nil Then
      For i := 0 To aIn.length - 1 Do
        write(f, Format('%2.8f', [TPArrayDouble(aIn.Buffer^)[i]]), ';');
    writeln(f);
  End;

Begin
  If Layers = Nil Then
    exit;

  assignFile(f, sFilename);
  Rewrite(f);

  writeln(f, '//==========================================================');
  writeln(f, '//==========================================================');
  writeln(f, '//Manufactor: MGSAI ');
  writeln(f, '//Version: 1000');
  writeln(f, '//Export: ' + DatetimeToStr(Now));
  writeln(f, '//File: ' + sFilename);
  writeln(f, '//Name: CIFAR-10');
  writeln(f, '//Author: Marcus H�ller-Schlieper');
  writeln(f, '//==========================================================');
  writeln(f, '//==========================================================');

  StoreUserData;
  writeln(f, '//==========================================================');
  StoreLearningInfo;
  writeln(f, '//==========================================================');
  StoreStructure;

  writeln(f, '');
  Try
    For iLayerIDX := 0 To Layers.Count - 1 Do
    Begin
      // Lade den Layer
      s := Layers[iLayerIDX];
      writeln(f,
        '//==========================================================');
      writeln(f,
        '//==========================================================');
      writeln(f, '//WEIGHTS ' + s.sName + '|' + s.layer_type);
      writeln(f,
        '//==========================================================');
      writeln(f,
        '//==========================================================');

      writeln(f, '[Layer_' + inttostr(iLayerIDX) + ']');
      writeln(f, 'Name=' + s.sName);
      writeln(f, 'Layer_Type=' + s.layer_type);
      writeln(f, Format('In_SX_Len=%2.2d', [s.in_act.sx]));
      writeln(f, Format('In_SY_Len=%2.2d', [s.in_act.sy]));

      writeln(f, Format('Out_SX_Len=%2.2d', [s.out_sx]));
      writeln(f, Format('Out_SY_Len=%2.2d', [s.out_sy]));

      if s.in_act.w = nil then
        writeln(f, Format('IN_ACT_W_Len= %2.2d', [0]))
      else
        writeln(f, Format('IN_ACT_W_Len= %2.2d', [s.in_act.w.length]));

      write(f, 'IN_ACT_W_Data=');
      StoreArray(s.in_act.w);

      writeln(f, Format('IN_ACT_DW_Len= %2.2d', [s.in_act.w.length]));
      write(f, 'IN_ACT_DW_Data=');
      StoreArray(s.in_act.dw);

      writeln(f, Format('OUT_ACT_DW_Len= %2.2d', [s.out_act.w.length]));
      write(f, 'Out_ACT_W_Data=');
      StoreArray(s.out_act.w);

      writeln(f, Format('OUT_ACT_DW_Len= %2.2d', [s.out_act.w.length]));
      write(f, 'OUT_ACT_DW_Data=');
      StoreArray(s.out_act.dw);

      If s Is TConvLayer Then
      Begin
        For iFilterIDX := 0 To TConvLayer(s).filters.length - 1 Do
        Begin
          writeln(f, Format('FILTER_W_' + inttostr(iFilterIDX) + '= %2.2d',
            [TConvLayer(s).filters.Buffer^[iFilterIDX].w.length]));
          write(f, 'FILTER_W_Data_' + inttostr(iFilterIDX) + '=');
          StoreArray(TConvLayer(s).filters.Buffer^[iFilterIDX].w);

          writeln(f, Format('FILTER_DW_' + inttostr(iFilterIDX) + '= %2.2d',
            [TConvLayer(s).filters.Buffer^[iFilterIDX].dw.length]));
          write(f, 'FILTER_DW_Data_' + inttostr(iFilterIDX) + '=');
          StoreArray(TConvLayer(s).filters.Buffer^[iFilterIDX].dw);
        End;

        writeln(f, Format('FILTER_BIAS_W= %2.2d',
          [TConvLayer(s).biases.w.length]));
        write(f, 'FILTER_Bias_W_Data=');
        StoreArray(TConvLayer(s).biases.w);

        writeln(f, Format('FILTER_BIAS_DW= %2.2d',
          [TConvLayer(s).biases.dw.length]));
        write(f, 'FILTER_Bias_DW_Data=');
        StoreArray(TConvLayer(s).biases.dw);
      End;

      If s Is TFullyConnLayer Then
      Begin
        For iFilterIDX := 0 To TFullyConnLayer(s).filters.length - 1 Do
        Begin
          writeln(f, Format('FILTER_W_' + inttostr(iFilterIDX) + '= %2.2d',
            [TConvLayer(s).filters.Buffer^[iFilterIDX].w.length]));
          write(f, 'FILTER_W_Data_' + inttostr(iFilterIDX) + '=');
          StoreArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].w);
          writeln(f, Format('FILTER_DW_' + inttostr(iFilterIDX) + '= %2.2d',
            [TConvLayer(s).filters.Buffer^[iFilterIDX].dw.length]));
          write(f, 'FILTER_DW_Data_' + inttostr(iFilterIDX) + '=');
          StoreArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].dw);

        End;
        writeln(f, Format('FILTER_BIAS_W= %2.2d',
          [TConvLayer(s).biases.w.length]));
        write(f, 'FILTER_Bias_W_Data=');
        StoreArray(TFullyConnLayer(s).biases.w);

        writeln(f, Format('FILTER_BIAS_DW= %2.2d',
          [TConvLayer(s).biases.dw.length]));
        write(f, 'FILTER_Bias_DW_Data=');
        StoreArray(TFullyConnLayer(s).biases.dw);
      End;

      If s Is TDropoutLayer Then
      Begin
        writeln(f, Format('Dropped= %2.2d', [TDropoutLayer(s).dropped.length]));
        write(f, 'Dropped_Data=');
        StoreArray(TDropoutLayer(s).dropped);
      End;

      If s Is TMaxoutLayer Then
      Begin
        writeln(f, Format('Switches: %2.2d',
          [TMaxoutLayer(s).switches.length]));
        write(f, 'Switches_Data=');
        StoreArray(TMaxoutLayer(s).switches);
      End;

    End;
  Finally
    CloseFile(f);
  End;
End;
// ==============================================================================
// Methode:
// Datum  : 09.02.2018
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Procedure TNet.CSVImport(sFilename: String; Trainer: TTrainer;
  Var LearningInfo: TLearningInfo);

Var
  iLayerIDX, iFilterIDX: Integer;
  s: TLayer;
  ListVolume: TList; // <TVolume>;
  vol: TVolume;
  k, d: Integer;
  ini: TInifile;
  sLayer: String;
  sLayerTyp: String;

  Procedure LoadLearningInfo;
  Begin
    LearningInfo.StartTraining := ini.ReadDateTime('LearningInfo',
      'StartTraining', Now);
    LearningInfo.TrainingDuration := ini.ReadInteger('LearningInfo',
      'TrainingDuration', 0);
    LearningInfo.iIterations := ini.ReadInteger('LearningInfo',
      'iIterations', 0);
    LearningInfo.ActAcc := ini.ReadFloat('LearningInfo', 'ActAcc', 0);
    LearningInfo.ActLoss := ini.ReadFloat('LearningInfo', 'ActLoss', 0);
  End;

  Procedure LoadUserData;
  Begin
    Trainer.options.method := ini.ReadString('Options', 'method', 'adadelta');
    Trainer.options.batch_size := ini.ReadInteger('Options', 'batch_size', 4);
    Trainer.options.learning_rate := ini.ReadFloat('Options',
      'learning_rate', 0.001);
    Trainer.options.momentum := ini.ReadFloat('Options', 'momentum', 0.9);
    Trainer.options.l1_decay := ini.ReadFloat('Options', 'l1_decay', 0.0);
    Trainer.options.l2_decay := ini.ReadFloat('Options', 'l2_decay', 0.0001);
    Trainer.options.ro := ini.ReadFloat('Options', 'ro', 0.95);
    Trainer.options.eps := ini.ReadFloat('Options', 'eps', 1E-6);
  End;

  Procedure LoadStructure;
  Var
    iLayerIDX: Integer;
    Layers: TList;
  Begin
    Layers := TList.create;
    Layers.Clear;

    For iLayerIDX := 0 To 100 Do
    Begin
      sLayer := 'Layer_' + inttostr(iLayerIDX);

      If ini.SectionExists(sLayer) Then
      Begin

        sLayerTyp := lowercase(ini.ReadString(sLayer, 'Type', 'unknown'));

        If sLayerTyp = 'input' Then
          Layers.Add(CreateOpt_Input(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), ini.ReadInteger(sLayer, 'out_sx', 0),
            ini.ReadInteger(sLayer, 'out_sy', 0), ini.ReadInteger(sLayer,
            'out_depth', 0)))
        Else If sLayerTyp = 'conv' Then
          Layers.Add(CreateOpt_Conv(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), ini.ReadInteger(sLayer, 'sx', 0),
            // Math.floor((in_sx + pad * 2 - sx) / stride + 1);
            ini.ReadInteger(sLayer, 'Filters', 0), ini.ReadInteger(sLayer,
            'Stride', 0), ini.ReadInteger(sLayer, 'Pad', 0), 'unknown'))
        Else If sLayerTyp = 'pool' Then
          Layers.Add(CreateOpt_Pool(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), ini.ReadInteger(sLayer, 'sx', 0),
            ini.ReadInteger(sLayer, 'Stride', 0)))
        Else If sLayerTyp = 'dropout' Then
          Layers.Add(CreateOpt_Dropout(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), ini.ReadFloat(sLayer, 'drop_prob', 0)))
        Else If sLayerTyp = 'fc' Then
          Layers.Add(CreateOpt_Hidden(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), 'fc', ini.ReadInteger(sLayer,
            'num_neurons', 0), 'NONE'))

        Else If sLayerTyp = 'softmax' Then
          Layers.Add(CreateOpt_Hidden(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), 'softmax', ini.ReadInteger(sLayer,
            'num_inputs', 0), 'NONE'))
        Else If sLayerTyp = 'svm' Then
          Layers.Add(CreateOpt_Hidden(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), 'svm', ini.ReadInteger(sLayer,
            'num_inputs', 0), 'NONE'))
        Else If sLayerTyp = 'regression' Then
          Layers.Add(CreateOpt_Hidden(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), 'regression', ini.ReadInteger(sLayer,
            'num_inputs', 0), 'NONE'))
        Else If sLayerTyp = 'relu' Then
          Layers.Add(CreateOpt_Hidden(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), 'relu', ini.ReadInteger(sLayer,
            'num_inputs', 0), 'NONE'))
        Else If sLayerTyp = 'sigmoid' Then
          Layers.Add(CreateOpt_Hidden(ini.ReadString(sLayer, 'Name',
            'L' + inttostr(iLayerIDX)), 'sigmoid', ini.ReadInteger(sLayer,
            'num_inputs', 0), 'NONE'))
        Else
          showmessage('Layertype "' + sLayerTyp + '" not known');

        { If s Is TMaxoutLayer Then
          Begin
          writeln(f, 'num_inputs=' + inttostr(TMaxoutLayer(s).num_inputs));
          writeln(f, 'group_size=' + inttostr(TMaxoutLayer(s).group_size));
          End;
        }
      End;
    End;

    makeLayers(Layers);
  End;

  Procedure LoadArray(aIn: TMyArray);
  Var
    i: Integer;
  Begin
    { If aIn <> Nil Then
      For i := 0 To aIn.length - 1 Do
      write(f, Format('%2.8f', [TPArrayDouble(aIn.Buffer^)[i]]), ';'); }
  End;

Begin
  If Layers = Nil Then
    exit;

  ini := TInifile.create(sFilename);
  Try

    LoadUserData;
    LoadLearningInfo;
    LoadStructure;

    For iLayerIDX := 0 To Layers.Count - 1 Do
    Begin
      // Lade den Layer
      s := Layers[iLayerIDX];

      { writeln(f, '[' + s.sName + ']');
        writeln(f, 'Name=' + s.sName);
        writeln(f, 'Layer_Type=' + s.layer_type);
        writeln(f, Format('In_SX_Len=%2.2d', [s.in_act.sx]));
        writeln(f, Format('In_SY_Len=%2.2d', [s.in_act.sy]));

        writeln(f, Format('Out_SX_Len=%2.2d', [s.out_sx]));
        writeln(f, Format('Out_SY_Len=%2.2d', [s.out_sy]));

        writeln(f, Format('IN_ACT_W_Len= %2.2d', [s.in_act.w.length]));
        write(f, 'IN_ACT_W_Data=');
        StoreArray(s.in_act.w);

        writeln(f, Format('IN_ACT_DW_Len= %2.2d', [s.in_act.w.length]));
        write(f, 'IN_ACT_DW_Data=');
        StoreArray(s.in_act.dw);

        writeln(f, Format('OUT_ACT_DW_Len= %2.2d', [s.out_act.w.length]));
        write(f, 'Out_ACT_W_Data=');
        StoreArray(s.out_act.w);

        writeln(f, Format('OUT_ACT_DW_Len= %2.2d', [s.out_act.w.length]));
        write(f, 'OUT_ACT_DW_Data=');
        StoreArray(s.out_act.dw);

        If s Is TConvLayer Then
        Begin
        For iFilterIDX := 0 To TConvLayer(s).filters.length - 1 Do
        Begin
        writeln(f, Format('FILTER_W_' + inttostr(iFilterIDX) + '= %2.2d', [TConvLayer(s).filters.Buffer^[iFilterIDX].w.length]));
        write(f, 'FILTER_W_Data_' + inttostr(iFilterIDX) + '=');
        StoreArray(TConvLayer(s).filters.Buffer^[iFilterIDX].w);

        writeln(f, Format('FILTER_DW_' + inttostr(iFilterIDX) + '= %2.2d', [TConvLayer(s).filters.Buffer^[iFilterIDX].dw.length]));
        write(f, 'FILTER_DW_Data_' + inttostr(iFilterIDX) + '=');
        StoreArray(TConvLayer(s).filters.Buffer^[iFilterIDX].dw);
        End;

        writeln(f, Format('FILTER_BIAS_W= %2.2d', [TConvLayer(s).biases.w.length]));
        write(f, 'FILTER_Bias_W_Data=');
        StoreArray(TConvLayer(s).biases.w);

        writeln(f, Format('FILTER_BIAS_DW= %2.2d', [TConvLayer(s).biases.dw.length]));
        write(f, 'FILTER_Bias_DW_Data=');
        StoreArray(TConvLayer(s).biases.dw);
        End;

        If s Is TFullyConnLayer Then
        Begin
        For iFilterIDX := 0 To TFullyConnLayer(s).filters.length - 1 Do
        Begin
        writeln(f, Format('FILTER_W_' + inttostr(iFilterIDX) + '= %2.2d', [TConvLayer(s).filters.Buffer^[iFilterIDX].w.length]));
        write(f, 'FILTER_W_Data_' + inttostr(iFilterIDX) + '=');
        StoreArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].w);
        writeln(f, Format('FILTER_DW_' + inttostr(iFilterIDX) + '= %2.2d', [TConvLayer(s).filters.Buffer^[iFilterIDX].dw.length]));
        write(f, 'FILTER_DW_Data_' + inttostr(iFilterIDX) + '=');
        StoreArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].dw);

        End;
        writeln(f, Format('FILTER_BIAS_W= %2.2d', [TConvLayer(s).biases.w.length]));
        write(f, 'FILTER_Bias_W_Data=');
        StoreArray(TFullyConnLayer(s).biases.w);

        writeln(f, Format('FILTER_BIAS_DW= %2.2d', [TConvLayer(s).biases.dw.length]));
        write(f, 'FILTER_Bias_DW_Data=');
        StoreArray(TFullyConnLayer(s).biases.dw);
        End;

        If s Is TDropoutLayer Then
        Begin
        writeln(f, Format('Dropped= %2.2d', [TDropoutLayer(s).dropped.length]));
        write(f, 'Dropped_Data=');
        StoreArray(TDropoutLayer(s).dropped);
        End;

        If s Is TMaxoutLayer Then
        Begin
        writeln(f, Format('Switches: %2.2d', [TMaxoutLayer(s).switches.length]));
        write(f, 'Switches_Data=');
        StoreArray(TMaxoutLayer(s).switches);
        End;
      }
    End;
  Finally
    ini.Free;
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 15.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Procedure TNet.Export;
Var
  iLayerIDX, iFilterIDX: Integer;
  s: TLayer;
  ListVolume: TList; // <TVolume>;
  vol: TVolume;
  k, d: Integer;

  Stream: TFileStream;
  sFilename: String;

  Procedure StoreArray(aIn: TMyArray);
  Begin
    If aIn <> Nil Then
      Stream.write(TPArrayDouble(aIn.Buffer^)[0], aIn.length * sizeof(Double));
  End;

Begin
  If Layers = Nil Then
    exit;

  sFilename := sWightsFilename;

  If Not Fileexists(sFilename) Then
    Stream := TFileStream.create(sFilename, fmCreate)
  Else
    Stream := TFileStream.create(sFilename, fmOpenWrite);

  Try
    Stream.Size := 0;
    Stream.Position := 0;
    For iLayerIDX := 0 To Layers.Count - 1 Do
    Begin
      // Lade den Layer
      s := Layers[iLayerIDX];

      //StoreArray(s.in_act.w);
      // if s.in_act <> nil then
      // if s.in_act.dw <> nil then
      // StoreArray(s.in_act.dw);

      //StoreArray(s.out_act.w);
      // if s.out_act <> nil then
      // if s.out_act.dw <> nil then
      // StoreArray(s.out_act.dw);

      // ========================================
      If s Is TConvLayer Then
      Begin

        For iFilterIDX := 0 To TConvLayer(s).out_depth - 1 Do
        Begin
          StoreArray(TConvLayer(s).filters.Buffer^[iFilterIDX].w);
          // StoreArray(TConvLayer(s).filters.Buffer^[iFilterIDX].dw);
        End;

        StoreArray(TConvLayer(s).biases.w);
        // StoreArray(TConvLayer(s).biases.dw);
      End;
      // ========================================
      If s Is TFullyConnLayer Then
      Begin
        For iFilterIDX := 0 To TFullyConnLayer(s).out_depth - 1 Do
        Begin
          StoreArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].w);
          // StoreArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].dw);
        End;

        StoreArray(TFullyConnLayer(s).biases.w);
        // StoreArray(TFullyConnLayer(s).biases.dw);
      End;
      // ========================================

   {   If s Is TPoolLayer Then
      Begin
        StoreArray(TPoolLayer(s).switchx);
        StoreArray(TPoolLayer(s).switchy);
      End;

      If s Is TDropoutLayer Then
      Begin
        StoreArray(TDropoutLayer(s).dropped);
      End;
      // ========================================
      If s Is TMaxoutLayer Then
      Begin
        StoreArray(TMaxoutLayer(s).switches);
      End;

      if s is TSigmoidLayer then
      begin
        StoreArray(TSigmoidLayer(s).es);
      end;

      if s is TReluLayer then
      begin
        StoreArray(TReluLayer(s).es);
      end;

      if s is TRegressionLayer then
      begin
        StoreArray(TRegressionLayer(s).es);
      end;

      if s is TSVMLayer then
      begin
        StoreArray(TSVMLayer(s).es);
      end;

      if s is TSoftmaxLayer then
      begin
        StoreArray(TSoftmaxLayer(s).es);
      end;     }
    End;
  Finally
    Stream.Free
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 15.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Procedure TNet.Import;
Var
  iLayerIDX, iFilterIDX: Integer;
  s: TLayer;
  ListVolume: TList; // <TVolume>;
  vol: TVolume;
  k, d: Integer;
  sFilename: String;

  Stream: TFileStream;

  Procedure ReadArray(aIn: TMyArray);
  Begin
    If aIn <> Nil Then
    Begin
      Stream.Read(TPArrayDouble(aIn.Buffer^)[0], aIn.length * sizeof(Double));
    End;
  End;

Begin
  sFilename := sWightsFilename;

  If Fileexists(sFilename) Then
  Begin
    Stream := TFileStream.create(sFilename, fmOpenRead);
    Try
      Stream.Position := 0;
      For iLayerIDX := 0 To Layers.Count - 1 Do
      Begin
        // Lade den Layer
        s := Layers[iLayerIDX];

        //ReadArray(s.in_act.w);

        //ReadArray(s.out_act.w);

        // ========================================
        If s Is TConvLayer Then
        Begin
          For iFilterIDX := 0 To TConvLayer(s).out_depth - 1 Do
          Begin
            ReadArray(TConvLayer(s).filters.Buffer^[iFilterIDX].w);
            // ReadArray(TConvLayer(s).filters.Buffer^[iFilterIDX].dw);

          End;
          ReadArray(TConvLayer(s).biases.w);
          // ReadArray(TConvLayer(s).biases.dw);
        End;

        // ========================================
        If s Is TFullyConnLayer Then
        Begin
          For iFilterIDX := 0 To TFullyConnLayer(s).out_depth - 1 Do
          Begin
            ReadArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].w);
            // ReadArray(TFullyConnLayer(s).filters.Buffer^[iFilterIDX].dw);

          End;
          ReadArray(TFullyConnLayer(s).biases.w);
          // ReadArray(TFullyConnLayer(s).biases.dw);
        End;

     {   If s Is TPoolLayer Then
        Begin
          ReadArray(TPoolLayer(s).switchx);
          ReadArray(TPoolLayer(s).switchy);
        End;

        // ========================================
        If s Is TDropoutLayer Then
        Begin
          ReadArray(TDropoutLayer(s).dropped);
        End;

        If s Is TMaxoutLayer Then
        Begin
          ReadArray(TMaxoutLayer(s).switches);
        End;

        if s is TSigmoidLayer then
        begin
          ReadArray(TSigmoidLayer(s).es);
        end;

        if s is TReluLayer then
        begin
          ReadArray(TReluLayer(s).es);
        end;

        if s is TRegressionLayer then
        begin
          ReadArray(TRegressionLayer(s).es);
        end;

        if s is TSVMLayer then
        begin
          ReadArray(TSVMLayer(s).es);
        end;

        if s is TSoftmaxLayer then
        begin
          ReadArray(TSoftmaxLayer(s).es);
        end;  }

      End;
    Finally
      Stream.Free
    End;
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Procedure TNet.makeLayers(Defs: TList); // <TOpt>);
Var
  def, new_def: TOpt;
  prev: TLayer;
  i: Integer;

  Function desugar(Defs: TList): TList; // <TOpt>
  Var
    new_defs: TList;
    def, new_def: TOpt;
    i: Integer;
    gs: Integer;
  Begin
    new_defs := TList.create;

    For i := 0 To Defs.Count - 1 Do
    Begin
      def := Defs[i];

      If (def.sType = 'softmax') Or (def.sType = 'svm') Then
      Begin
        // add an fc layer here, there is no reason the user should
        // have to worry about this and we almost always want to
        new_def := TOpt.create;
        new_def.sType := 'fc';
        new_def.sName := def.sName + '_' + new_def.sType;
        new_def.num_neurons := def.num_classes;

        new_defs.Add(new_def);
      End;

      If (def.sType = 'regression') Then
      Begin
        // add an fc layer here, there is no reason the user should
        // have to worry about this and we almost always want to
        new_def := TOpt.create;
        new_def.sType := 'fc';
        new_def.sName := def.sName + '_' + new_def.sType;
        new_def.num_neurons := def.num_classes;

        new_defs.Add(new_def);
      End;

      If ((def.sType = 'fc') Or (def.sType = 'conv')) And
        (def.bias_pref = c_Undefined) Then
      Begin
        def.bias_pref := 0.0;
        If (def.activation <> 'undefined') And (def.activation = 'relu') Then
        Begin
          def.bias_pref := 0.1;
          // relus like a bit of positive bias to get gradients early
          // otherwise it's technically possible that a relu unit will never turn on (by chance)
          // and will never get any gradient and never contribute any computation. Dead relu.
        End;
      End;

      new_defs.Add(def);

      If (def.activation <> 'undefined') Then
      Begin
        If (def.activation = 'relu') Then
        Begin
          new_def := TOpt.create;
          new_def.sType := 'relu';
          new_def.sName := def.sName + '_' + new_def.sType;
          new_defs.Add(new_def);
        End
        Else If (def.activation = 'sigmoid') Then
        Begin
          new_def := TOpt.create;
          new_def.sType := 'sigmoid';
          new_def.sName := def.sName + '_' + new_def.sType;
          new_defs.Add(new_def);
        End
        Else If (def.activation = 'tanh') Then
        Begin
          new_def := TOpt.create;
          new_def.sType := 'tanh';
          new_def.sName := def.sName + '_' + new_def.sType;
          new_defs.Add(new_def);
        End
        Else If (def.activation = 'maxout') Then
        Begin
          // create maxout activation, and pass along group size, if provided

          If def.group_size = c_Undefined Then
            gs := 2
          Else
            gs := def.group_size;

          new_def := TOpt.create;
          new_def.sType := 'maxout';
          new_def.sName := def.sName + '_' + new_def.sType;
          new_def.group_size := gs;
          new_defs.Add(new_def);
        End
        Else
        Begin
          assert(true, 'ERROR unsupported activation ' + def.activation);
        End
      End;

      If (def.drop_prob <> c_Undefined) And (def.sType <> 'dropout') Then
      Begin
        new_def := TOpt.create;
        new_def.sType := 'dropout';
        new_def.sName := def.sName + '_' + new_def.sType;
        new_def.drop_prob := def.drop_prob;
      End;

    End;
    Defs.Free; // ????

    result := new_defs;
  End;

Begin
  assert(Defs.Count >= 2,
    'Error! At least one input layer and one loss layer are required.');
  assert(TOpt(Defs[0]).sType = 'input',
    'Error! First layer must be the input layer, to declare size of inputs');

  Defs := desugar(Defs);

  If Layers = Nil Then
    Layers := TList.create;

  Layers.Clear;

  For i := 0 To Defs.Count - 1 Do
  Begin
    def := Defs[i];
    If (i > 0) Then
    Begin
      prev := Layers[i - 1];
      def.in_sx := prev.out_sx;
      def.in_sy := prev.out_sy;
      def.in_depth := prev.out_depth;
    End;

    If lowercase(def.sType) = 'fc' Then
      Layers.Add(TFullyConnLayer.create(def))
    Else If lowercase(def.sType) = 'dropout' Then
      Layers.Add(TDropoutLayer.create(def))
    Else If lowercase(def.sType) = 'input' Then
      Layers.Add(TInputLayer.create(def))
    Else If lowercase(def.sType) = 'softmax' Then
      Layers.Add(TSoftmaxLayer.create(def))
    Else If lowercase(def.sType) = 'regression' Then
      Layers.Add(TRegressionLayer.create(def))
    Else If lowercase(def.sType) = 'conv' Then
      Layers.Add(TConvLayer.create(def))
    Else If lowercase(def.sType) = 'pool' Then
      Layers.Add(TPoolLayer.create(def))
    Else If lowercase(def.sType) = 'relu' Then
      Layers.Add(TReluLayer.create(def))
    Else If lowercase(def.sType) = 'sigmoid' Then
      Layers.Add(TSigmoidLayer.create(def))
    Else If lowercase(def.sType) = 'tanh' Then
      Layers.Add(TTanhLayer.create(def))
    Else If lowercase(def.sType) = 'maxout' Then
      Layers.Add(TMaxoutLayer.create(def))
    Else If lowercase(def.sType) = 'svm' Then
      Layers.Add(TSVMLayer.create(def))
    Else
    Begin
      showmessage('ERROR: UNRECOGNIZED LAYER TYPE: ' + def.sType);
    End;

    If def.sName = '' Then
      def.sName := def.sType + '_' + inttostr(i);
    TLayer(Layers[i]).sName := def.sName;
  End;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TNet.forward(Var volInput: TVolume; is_training: Boolean): TVolume;
Var
  act: TVolume;
  act_old: TVolume;
  i: Integer;
  dtStart: Int64;
Begin
  act := Nil;
  If volInput <> Nil Then
  Begin
    dtStart := GetTickCount;
    act := TLayer(Layers[0]).forward(volInput, is_training);
    TLayer(Layers[0]).fwTime := (GetTickCount - dtStart);
    For i := 1 To Layers.Count - 1 Do
    Begin
      dtStart := GetTickCount;
      act := TLayer(Layers[i]).forward(act, is_training);
      TLayer(Layers[i]).fwTime := (GetTickCount - dtStart);
    End;
  End;
  result := act;

  {
    v := net.Forward(x, true); // also set the flag that lets the net know we're just training
    dtEnd := GetTickCount;
    result.fwd_time := (dtEnd - dtStart) * 1000; }
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TNet.getCostLoss(volInput: TVolume; arrOut: TMyArray): Double;
Var
  n: Integer;
  loss: Double;
  act: TVolume;
Begin
  act := forward(volInput, False);
  act.Free;
  n := Layers.Count;
  loss := TLayer(Layers[n - 1]).backwardOutput(arrOut);
  result := loss;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TNet.backward(arrOut: TMyArray): Double;
Var
  n, i: Integer;
  loss: Double;
  dtEnd, dtStart: Int64;
Begin
  loss := 0;
  If arrOut <> Nil Then
  Begin
    n := Layers.Count;

    dtStart := GetTickCount;
    If TLayer(Layers[n - 1]) Is TSoftmaxLayer Then
    Begin
      i := round(TPArrayDouble(arrOut.Buffer^)[0]);
      loss := TLayer(Layers[n - 1]).backwardLoss(i)
    End
    Else
      loss := TLayer(Layers[n - 1]).backwardOutput(arrOut);
    // last layer assumed to be loss layer

    TLayer(Layers[n - 1]).bwTime := (GetTickCount - dtStart);

    For i := n - 2 Downto 0 Do
    Begin // first layer assumed input
      dtStart := GetTickCount;
      TLayer(Layers[i]).backward();
      TLayer(Layers[i]).bwTime := (GetTickCount - dtStart);
    End;
  End;
  result := loss;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TNet.getParamsAndGrads: TList;
Var
  Response: TList;
  layer_reponse: TList;
  i, j: Integer;
Begin
  // accumulate parameters and gradients for the entire network
  Response := TList.create;
  For i := 0 To Layers.Count - 1 Do
  Begin
    layer_reponse := TLayer(Layers[i]).getParamsAndGrads();
    If layer_reponse <> Nil Then
    Begin
      // kopiere die Layer - Responseliste
      For j := 0 To layer_reponse.Count - 1 Do
      Begin
        Response.Add(layer_reponse[j]);
      End;

      layer_reponse.Free; // die Liste kann nun gel�scht werden.....
    End;

  End;
  result := Response;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TNet.getPrediction(iBestAmount: Integer): TList;
Var
  s: TLayer;
  p: TMyArray;
  maxv: Double;
  sLastMaxV: Double;
  maxi: Integer;
  i: Integer;
  k: Integer;
  Predict: TPredict;
  tmp: Double;

Begin
  result := TList.create;

  sLastMaxV := 10000000;

  // this is a convenience function for returning the argmax
  // prediction, assuming the last layer of the net is a softmax
  s := Layers[Layers.Count - 1];
  assert(s.layer_type = 'softmax',
    'getPrediction function assumes softmax as last layer of the net!');

  For i := 0 To s.out_act.w.length - 1 Do
  Begin
    Predict := TPredict.create;
    Predict.iPosition := i;
    Predict.iLabel := i;
    Predict.sLikeliHood := TPArrayDouble(s.out_act.w.Buffer^)[i];

    If result.Count = 0 Then
      result.Add(Predict)
    Else
    Begin
      k := 0;
      While (k < result.Count) And
        (TPredict(result[k]).sLikeliHood > Predict.sLikeliHood) Do
        inc(k);

      // hinten anf�gen oder einf�gen
      If k >= result.Count Then
        result.Add(Predict)
      Else
        result.Insert(k, Predict);
    End;
  End;

  { p := s.out_act.w;
    For k := 0 To iBestAmount - 1 Do
    Begin
    maxv := TPArrayDouble(p.Buffer^)[0];
    maxi := 0;
    For i := 1 To p.length - 1 Do
    Begin
    If (TPArrayDouble(p.Buffer^)[i] > maxv) And (TPArrayDouble(p.Buffer^)[i] < sLastMaxV) Then
    Begin
    maxv := TPArrayDouble(p.Buffer^)[i];
    maxi := i;
    End
    End;

    Predict := TPredict.Create;
    Predict.iPosition := k;
    Predict.iLabel := maxi;
    Predict.sLikeliHood := maxv;

    result.Add(Predict);

    sLastMaxV := maxv;
    End; }

End;
// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TNet.getPrediction: Integer;
Var
  s: TLayer;
  p: TMyArray;
  maxv: Double;
  maxi: Integer;
  i: Integer;
Begin

  // this is a convenience function for returning the argmax
  // prediction, assuming the last layer of the net is a softmax
  s := Layers[Layers.Count - 1];
  assert(s.layer_type = 'softmax',
    'getPrediction function assumes softmax as last layer of the net!');

  p := s.out_act.w;

  maxv := TPArrayDouble(p.Buffer^)[0];
  maxi := 0;
  For i := 1 To p.length - 1 Do
  Begin
    If (TPArrayDouble(p.Buffer^)[i] > maxv) Then
    Begin
      maxv := TPArrayDouble(p.Buffer^)[i];
      maxi := i;
    End
  End;
  result := maxi;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Constructor TTrainer.create(_net: TNet; _options: TTrainerOpt);
Begin
  net := _net;
  options := _options;
  iFrameCounterForBatch := 0; // iteration counter
  gsum := TList.create;
  // last iteration gradients (used for momentum calculations)
  xsum := TList.create; // used in adadelta
  TrainReg := TTrainReg.create;

  beta1 := 0.9;
  beta2 := 0.999;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TTrainer.destroy;
Var
  i: Integer;
Begin
  For i := 0 To gsum.Count - 1 Do
    TMyArray(gsum[i]).Free;

  For i := 0 To xsum.Count - 1 Do
    TMyArray(xsum[i]).Free;

  freeandnil(gsum);
  freeandnil(xsum);

  TrainReg.Free;
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Function TTrainer.train(Var volInput: TVolume; Var arrOut: TMyArray): TTrainReg;
Var
  dtStart, dtEnd: Int64;
  i, j: Integer;
  pglist: TList;
  pg: TResponse;
  Parameter, Grads: TMyArray;
  l2_decay_mul: Double;
  l1_decay_mul: Double;
  l2_decay: Double;
  l1_decay: Double;

  l1grad: Double;
  l2grad: Double;

  pLen: Integer;
  gij: Double;

  gsumi: TMyArray;
  xsumi: TMyArray;
  dx: Double;
  act: TVolume;
  vPredict: TVolume;

  biasCorr1, biasCorr2: Double;
Begin
  result := TrainReg;

  dtStart := GetTickCount;
  vPredict := net.forward(volInput, true);
  // also set the flag that lets the net know we're just training
  dtEnd := GetTickCount;
  result.fwd_time := (dtEnd - dtStart) * 1000;

  dtStart := GetTickCount;
  result.cost_loss := net.backward(arrOut);
  dtEnd := GetTickCount;
  result.bwd_time := (dtEnd - dtStart) * 1000;

  result.l2_decay_loss := 0.0;
  result.l1_decay_loss := 0.0;

  If options.ro = 0 Then
    options.ro := 0.95;

  If options.eps = 0 Then
    options.eps := 1E-6;

  inc(iFrameCounterForBatch);

  If (iFrameCounterForBatch Mod options.batch_size = 0) Then
  Begin
    pglist := net.getParamsAndGrads();
    Try
      // initialize lists for accumulators. Will only be done once on first iteration
      If (gsum.Count = 0) And ((options.method <> 'sgd') Or
        (options.momentum > 0.0)) Then
      Begin
        // only vanilla sgd doesnt need either lists
        // momentum needs gsum
        // adagrad needs gsum
        // adadelta needs gsum and xsum
        For i := 0 To pglist.Count - 1 Do
        Begin
          gsum.Add(Global.Zeros(TResponse(pglist[i]).ptrFilter.length));
          If (options.method = 'adadelta') Then
          Begin
            xsum.Add(Global.Zeros(TResponse(pglist[i]).ptrFilter.length));
          End
          Else
          Begin
            xsum.Add(Nil); // conserve memory
          End;
        End
      End;

      // perform an update for all sets of weights
      For i := 0 To pglist.Count - 1 Do
      Begin
        pg := pglist[i];
        // param, gradient, other options in future (custom learning rate etc)
        Parameter := pg.ptrFilter;
        Grads := pg.ptrFilterGrads;

        // learning rate for some parameters.
        If pg.l2_decay_mul = c_Undefined Then
          l2_decay_mul := 1
        Else
          l2_decay_mul := pg.l2_decay_mul;

        If pg.l1_decay_mul = c_Undefined Then
          l1_decay_mul := 1
        Else
          l1_decay_mul := pg.l1_decay_mul;

        l2_decay := options.l2_decay * l2_decay_mul;
        l1_decay := options.l1_decay * l1_decay_mul;

        pLen := Parameter.length;
        For j := 0 To pLen - 1 Do
        Begin
          result.l2_decay_loss := result.l2_decay_loss + l2_decay *
            TPArrayDouble(Parameter.Buffer^)[j] *
            TPArrayDouble(Parameter.Buffer^)[j] / 2;
          // accumulate weight decay loss
          result.l1_decay_loss := result.l1_decay_loss + l1_decay *
            abs(TPArrayDouble(Parameter.Buffer^)[j]);

          // l1grad := l1_decay * (p[j] > 0 ? 1: - 1);
          If TPArrayDouble(Parameter.Buffer^)[j] > 0 Then
            l1grad := l1_decay
          Else
            l1grad := -l1_decay;

          l2grad := l2_decay * (TPArrayDouble(Parameter.Buffer^)[j]);

          gij := TPArrayDouble(Grads.Buffer^)[j];

          gij := (l2grad + l1grad + gij) / options.batch_size;
          // raw batch gradient

          gsumi := gsum[i];
          xsumi := xsum[i];

          // eine Lernmethoden ausw�hlen.....

          If (options.method = 'adam') Then
          Begin
            // adam update
            TPArrayDouble(gsumi.Buffer^)[j] := TPArrayDouble(gsumi.Buffer^)[j] *
              beta1 + (1 - beta1) * gij; // update biased first moment estimate
            TPArrayDouble(xsumi.Buffer^)[j] := TPArrayDouble(xsumi.Buffer^)[j] *
              beta2 + (1 - beta2) * gij * gij;
            // update biased second moment estimate
            biasCorr1 := TPArrayDouble(gsumi.Buffer^)[j] *
              (1 - Math.power(beta1, iFrameCounterForBatch));
            // correct bias first moment estimate
            biasCorr2 := TPArrayDouble(xsumi.Buffer^)[j] *
              (1 - Math.power(beta2, iFrameCounterForBatch));
            // correct bias second moment estimate
            dx := -options.learning_rate * biasCorr1 /
              (sqrt(biasCorr2) + options.eps);

            TPArrayDouble(Parameter.Buffer^)[j] :=
              TPArrayDouble(Parameter.Buffer^)[j] + dx;
          End
          Else If (options.method = 'adagrad') Then
          Begin
            // adagrad update
            TPArrayDouble(gsumi.Buffer^)[j] := TPArrayDouble(gsumi.Buffer^)[j] +
              gij * gij;
            dx := -options.learning_rate /
              sqrt(TPArrayDouble(gsumi.Buffer^)[j] + options.eps) * gij;
            TPArrayDouble(Parameter.Buffer^)[j] :=
              TPArrayDouble(Parameter.Buffer^)[j] + dx;
          End
          Else If (options.method = 'windowgrad') Then
          Begin

            // this is adagrad but with a moving window weighted average
            // so the gradient is not accumulated over the entire history of the run.
            // it's also referred to as Idea #1 in Zeiler paper on Adadelta. Seems reasonable to me!
            TPArrayDouble(gsumi.Buffer^)[j] := options.ro *
              TPArrayDouble(gsumi.Buffer^)[j] + (1 - options.ro) * gij * gij;
            dx := -options.learning_rate /
              sqrt(TPArrayDouble(gsumi.Buffer^)[j] + options.eps) * gij;
            // eps added for better conditioning
            TPArrayDouble(Parameter.Buffer^)[j] :=
              TPArrayDouble(Parameter.Buffer^)[j] + dx;
          End
          Else If (options.method = 'adadelta') Then
          Begin
            // assume adadelta if not sgd or adagrad
            TPArrayDouble(gsumi.Buffer^)[j] := options.ro *
              TPArrayDouble(gsumi.Buffer^)[j] + (1 - options.ro) * gij * gij;
            dx := -sqrt((TPArrayDouble(xsumi.Buffer^)[j] + options.eps) /
              (TPArrayDouble(gsumi.Buffer^)[j] + options.eps)) * gij;
            TPArrayDouble(xsumi.Buffer^)[j] := options.ro *
              TPArrayDouble(xsumi.Buffer^)[j] + (1 - options.ro) * dx * dx;
            // yes, xsum lags behind gsum by 1.
            TPArrayDouble(Parameter.Buffer^)[j] :=
              TPArrayDouble(Parameter.Buffer^)[j] + dx;
          End
          Else If (options.method = 'nesterov') Then
          Begin
            dx := TPArrayDouble(gsumi.Buffer^)[j];
            TPArrayDouble(gsumi.Buffer^)[j] := TPArrayDouble(gsumi.Buffer^)[j] *
              options.momentum + options.learning_rate * gij;
            dx := options.momentum * dx - (1.0 + options.momentum) *
              TPArrayDouble(gsumi.Buffer^)[j];
            TPArrayDouble(Parameter.Buffer^)[j] :=
              TPArrayDouble(Parameter.Buffer^)[j] + dx;
          End
          Else
          Begin
            // assume SGD
            If (options.momentum > 0.0) Then
            Begin
              // momentum update
              dx := options.momentum * TPArrayDouble(gsumi.Buffer^)[j] -
                options.learning_rate * gij; // step
              TPArrayDouble(gsumi.Buffer^)[j] := dx;
              // back this up for next iteration of momentum
              TPArrayDouble(Parameter.Buffer^)[j] :=
                TPArrayDouble(Parameter.Buffer^)[j] + dx;
              // apply corrected gradient
            End
            Else
            Begin
              // vanilla sgd
              TPArrayDouble(Parameter.Buffer^)[j] :=
                TPArrayDouble(Parameter.Buffer^)[j] -
                options.learning_rate * gij;
            End;
          End;


          TPArrayDouble(Grads.Buffer^)[j] := 0.0;
          // zero out gradient so that we can begin accumulating a new
        End;
      End;
    Finally

      For i := 0 To pglist.Count - 1 Do
        TResponse(pglist[i]).Free;

      pglist.Free;
    End;
  End;

  result.loss := result.cost_loss + result.l1_decay_loss + result.l2_decay_loss;

  // appending softmax_loss for backwards compatibility, but from now on we will always use cost_loss
  // in future, TODO: have to completely redo the way loss is done around the network as currently
  // loss is a bit of a hack. Ideally, user should specify arbitrary number of loss functions on any layer
  // and it should all be computed correctly and automatically.

End;

// ==============================================================================
//
//
// ==============================================================================

Constructor TTrainData_Element.create(_sx, _sy, _depth, _OutVectorLen: Integer);
Begin
  InData := TVolume.create(_sx, _sy, _depth);
  OutData := TMyArray.create(_OutVectorLen);
End;

// ==============================================================================
//
//
// ==============================================================================

Destructor TTrainData_Element.destroy;
Begin
  InData.Free;
  OutData.Free;
  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Constructor TTrainData.create(_sx, _sy, _depth, _OutVectorLen: Integer);
Begin
  Inherited create;
  sx := _sx;
  sy := _sy;
  depth := _depth;
  OutVectorLen := _OutVectorLen;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Destructor TTrainData.destroy;
Var
  i, j: Integer;
Begin

  For i := 0 To Count - 1 Do
  Begin
    TTrainData_Element(items[i]).Free;
  End;

  Inherited;
End;

// ==============================================================================
// Methode:
// Datum  : 07.07.2017
// Autor  : M.H�ller-Schlieper
//
// ==============================================================================

Procedure TTrainData.AddTestData_1D(InValues, OutValues: Array Of Double);
Var
  i: Integer;
  TrainData_Element: TTrainData_Element;
Begin
  //
  TrainData_Element := TTrainData_Element.create(sx, sy, depth, OutVectorLen);

  // kopiere die InValues-Liste in die Input - Elementenliste
  For i := 0 To High(InValues) Do
    TrainData_Element.InData.setVal(i, 0, 0, InValues[i]);

  // kopiere die OutValues-Liste in die Output - Elementenliste
  For i := 0 To High(OutValues) Do
    TPArrayDouble(TrainData_Element.OutData.Buffer^)[i] := OutValues[i];

  // f�ge das Objekt hinzu
  Inherited Add(TrainData_Element);
End;

{ TResponse }

Destructor TResponse.destroy;
Var
  i: Integer;
Begin

  Inherited;
End;

{ TLayer }

Destructor TLayer.destroy;
Begin
  freeandnil(in_act);
  freeandnil(out_act);
  Inherited;
End;

Initialization

System.SysUtils.FormatSettings.Decimalseparator := '.';

Finalization

End.

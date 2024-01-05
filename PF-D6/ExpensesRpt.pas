unit ExpensesRpt;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, dmData, DB;

type
  TExpensesReport = class(TQuickRep)
    BandTitle: TQRBand;
    QRLabel1: TQRLabel;
    QRBand1: TQRBand;
    QRShape1: TQRShape;
    QRLabel2: TQRLabel;
    QRShape2: TQRShape;
    QRLabel3: TQRLabel;
    QRShape3: TQRShape;
    QRLabel4: TQRLabel;
    QRShape4: TQRShape;
    QRLabel5: TQRLabel;
    QRShape5: TQRShape;
    QRLabel6: TQRLabel;
    QRShape6: TQRShape;
    QRLabel7: TQRLabel;
    QRBand2: TQRBand;
    QRShape7: TQRShape;
    QRLabel8: TQRDBText;
    QRShape8: TQRShape;
    QRLabel9: TQRDBText;
    QRShape9: TQRShape;
    QRLabel10: TQRDBText;
    QRShape10: TQRShape;
    QRLabel11: TQRDBText;
    QRShape11: TQRShape;
    QRLabel12: TQRDBText;
    QRShape12: TQRShape;
    QRLabel13: TQRDBText;
  private

  public

  end;

implementation

{$R *.DFM}

end.

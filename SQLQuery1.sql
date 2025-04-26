IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroRegi' And so.id = si.id And so.name = 'SAPAGCXC') 
ALTER TABLE [dbo].SAPAGCXC WITH NOCHECK ADD NroRegi INT NOT NULL DEFAULT (0) WITH VALUES;
IF NOT EXISTS(select so.name from sysobjects so, syscolumns si where si.name = 'NroRegi' And so.id = si.id And so.name = 'SAPAGCXP') 
ALTER TABLE [dbo].SAPAGCXP WITH NOCHECK ADD NroRegi INT NOT NULL DEFAULT (0) WITH VALUES;
Update saitemfac Set CantMayor = 1 Where CantMayor=0;
DECLARE @NroUnico NUMERIC(28,0), @NroPpal NUMERIC(28,0),
        @TipoCxcC VARCHAR(3), @TipoCxcP VARCHAR(3);
DECLARE update_table CURSOR FOR
 Select PA.NroUnico, PA.NroPpal, PC.TipoCxC, PA.TipoCxC
 From SAACXC As PC, SAPAGCXC as PA, SACLIE as CL
 Where PC.CodClie = CL.CodClie And PC.NumeroD = pa.NumeroD And (PC.TipoCxc = '60')
 Order by CL.CodClie, PA.NroUnico, PC.TipoCxC, PC.NumeroD;
OPEN update_table;
FETCH NEXT FROM update_table INTO @NroUnico, @NroPpal, @TipoCxcC, @TipoCxcP;
WHILE @@FETCH_STATUS = 0
BEGIN
  UPDATE SAACXC SET TipoCxC='46'
   WHERE NroUnico=@NroPpal And TipoCxc='41';
  UPDATE SAPAGCXC SET TipoCxC='46'
   WHERE NroUnico=@NroUnico And TipoCxc='41';
  FETCH NEXT FROM update_table INTO @NroUnico, @NroPpal, @TipoCxcC, @TipoCxcP;
END;
CLOSE Update_table;
DEALLOCATE Update_table;
DECLARE Update_table CURSOR FOR
 Select PA.NroUnico, PA.NroPpal, PC.TipoCxP, PA.TipoCxP
 From  SAACXP as PC, SAPAGCXP as PA, SAPROV as CL
 Where PC.CodProv=CL.CodProv And PC.NumeroD=PA.NumeroD And (PC.TipoCxP = '60')
 Order By CL.CodProv, PA.NroUnico, PC.TipoCxP, PC.NumeroD;
OPEN Update_Table;
FETCH NEXT FROM update_table INTO @NroUnico, @NroPpal, @TipoCxcC, @TipoCxcP;
WHILE @@FETCH_STATUS=0
 BEGIN
   UPDATE SAACXP SET TipoCxP='46'
    WHERE NroUnico=@NroPpal And TipoCxP='41';
   UPDATE SAPAGCXP SET TipoCxP='46'
    WHERE NroUnico=@NroUnico And TipoCxP='41';
   FETCH NEXT FROM update_table INTO @NroUnico, @NroPpal, @TipoCxcC, @TipoCxcP;
 END;
CLOSE update_table;
DEALLOCATE update_table;
DECLARE @Tipo VARCHAR(2),   @NumeroD VARCHAR(20),
        @CodUbic VARCHAR(20), @NroLinea NUMERIC(28,0);
DECLARE @CodUser VARCHAR(255),  @CodItem VARCHAR(20),
        @Cantidad NUMERIC(28,2),  @NumPart INT;
DECLARE cursor_Ventas_item cursor for
 Select TipoFac, NumeroD, si.CodItem, si.NroLinea, Cantidad
 from saitemfac si
 Where NroLineaC=0
 Order By si.TipoFac, si.NumeroD, NroLinea, NroLineaC;
OPEN Cursor_Ventas_item;
FETCH NEXT FROM Cursor_Ventas_Item INTO @Tipo, @NumeroD, @CodItem, @NroLinea, @Cantidad;
WHILE @@FETCH_STATUS=0
BEGIN
 Select @NumPart = COUNT(CodItem) 
 From SAITEMFAC 
 Where NumeroD=@NumeroD And TipoFac = @Tipo And NroLineaC>0 And NroLinea=@NroLinea;
 If @NumPart>1
     Update SAITEMFAC SET CantMayor = @Cantidad
      Where NumeroD = @NumeroD And TipoFac = @Tipo And NroLineaC > 0 And NroLinea = @NroLinea;
 FETCH NEXT FROM cursor_Ventas_item INTO @Tipo, @NumeroD, @CodItem, @NroLinea, @Cantidad;
END;
CLOSE cursor_Ventas_item;
DEALLOCATE cursor_Ventas_item;
IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='SAESTA') 
    DROP TABLE [DBO].SAESTA;
CREATE TABLE [dbo].SAESTA ([CodEsta] VARCHAR(10) NOT NULL, [Descrip] VARCHAR(50) NOT NULL);
ALTER TABLE [dbo].SAESTA WITH NOCHECK ADD CONSTRAINT SAESTA_IX0 PRIMARY KEY CLUSTERED (CodEsta) ON [PRIMARY];
CREATE INDEX SAESTA_IX1 ON SAESTA  (Descrip) ON [PRIMARY];

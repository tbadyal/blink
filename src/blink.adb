with Interfaces.SAM.PIO;
with Interfaces.SAM.SYSC;
with Interfaces.SAM.UART;
with Interfaces.SAM.PMC;
--Tushar Badyal
procedure blink is   
   
   use type Interfaces.SAM.UInt32;
   
   PIOA : access Interfaces.SAM.PIO.PIO_Peripheral   := Interfaces.SAM.PIO.PIOA_Periph'Access;
   PIOB : access Interfaces.SAM.PIO.PIO_Peripheral   := Interfaces.SAM.PIO.PIOB_Periph'Access;
   PIOC : access Interfaces.SAM.PIO.PIO_Peripheral   := Interfaces.SAM.PIO.PIOC_Periph'Access;
   PIOD : access Interfaces.SAM.PIO.PIO_Peripheral   := Interfaces.SAM.PIO.PIOD_Periph'Access;
   RTT  : access Interfaces.SAM.SYSC.RTT_Peripheral  := Interfaces.SAM.SYSC.RTT_Periph'Access;
   WDT  : access Interfaces.SAM.SYSC.WDT_Peripheral  := Interfaces.SAM.SYSC.WDT_Periph'Access;
   UART : access Interfaces.SAM.UART.UART_Peripheral := Interfaces.SAM.UART.UART_Periph'Access;
   PMC  : access Interfaces.sam.PMC.PMC_Peripheral   := Interfaces.SAM.PMC.PMC_Periph'Access;
   
   procedure sleep_ms(milliseconds : Interfaces.SAM.UInt32) is
      sleep_unitl : Interfaces.SAM.UInt32 := RTT.VR + milliseconds;
   begin
      while  RTT.VR < sleep_unitl loop
         null;
      end loop;
   end sleep_ms;
   
begin

   PIOB.PER.Val := Interfaces.SAM.Shift_Left(1,27);
   PIOB.OER.Val := Interfaces.SAM.Shift_Left(1,27);
   RTT.MR.RTPRES := 32;
   WDT.MR.WDDIS := True;
   
   
   PIOA.IDR.Val := Interfaces.SAM.Shift_Left(1,8) or Interfaces.SAM.Shift_Left(1,9);
   PIOA.PDR.Val := Interfaces.SAM.Shift_Left(1,8) or Interfaces.SAM.Shift_Left(1,9);
   PIOA.ABSR.Val := PIOA.ABSR.val and not(Interfaces.SAM.Shift_Left(1,8) or Interfaces.SAM.Shift_Left(1,9));
   PIOA.PUER.val := Interfaces.SAM.Shift_Left(1,8) or Interfaces.SAM.Shift_Left(1,9);
   
   PMC.PMC_PCER0.PID.Val := 8;
   
   UART.CR.RSTRX := True;
   UART.CR.RSTTX := True;
   UART.CR.RXDIS := True;
   UART.CR.TXDIS := True;
   
   UART.BRGR.CD := 21;
   
   UART.MR.PAR := Interfaces.SAM.UART.NO;
   UART.MR.CHMODE := Interfaces.SAM.UART.NORMAL;
   
   UART.PTCR.RXTDIS := True;
   UART.PTCR.TXTDIS := True;
   
   UART.CR.RXEN := True;
   UART.CR.TXEN := True;
   
   
   loop
      while not UART.SR.TXRDY loop
         null;
      end loop;
      
      UART.THR.TXCHR := Character'pos('a');
      
      while not UART.SR.TXEMPTY loop
         null;
      end loop;
     
      PIOB.SODR.val := Interfaces.SAM.Shift_Left(1,27);
      sleep_ms(50);
      PIOB.CODR.val := Interfaces.SAM.Shift_Left(1,27);
      sleep_ms(50);
   end loop;
   
end blink;   

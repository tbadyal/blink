with Interfaces.SAM.PIO;
with Interfaces.SAM.SYSC;
with Interfaces.SAM.UART;
with Interfaces.SAM.PMC;

procedure blink is   
   
   use type Interfaces.SAM.UInt32;
   
   PIOA : access Interfaces.SAM.PIO.PIO_Peripheral := Interfaces.SAM.PIO.PIOA_Periph'Access;
   PIOB : access Interfaces.SAM.PIO.PIO_Peripheral := Interfaces.SAM.PIO.PIOB_Periph'Access;
   PIOC : access Interfaces.SAM.PIO.PIO_Peripheral := Interfaces.SAM.PIO.PIOC_Periph'Access;
   PIOD : access Interfaces.SAM.PIO.PIO_Peripheral := Interfaces.SAM.PIO.PIOD_Periph'Access;
   RTT : access Interfaces.SAM.SYSC.RTT_Peripheral := Interfaces.SAM.SYSC.RTT_Periph'Access;
   WDT : access Interfaces.SAM.SYSC.WDT_Peripheral := Interfaces.SAM.SYSC.WDT_Periph'Access;
   UART : access Interfaces.SAM.UART.UART_Peripheral := Interfaces.SAM.UART.UART_Periph'Access;
   PMC : access Interfaces.sam.PMC.PMC_Peripheral := Interfaces.SAM.PMC.PMC_Periph'Access;
   
   procedure sleep_ms(milliseconds : Interfaces.SAM.UInt32) is
      sleep_unitl : Interfaces.SAM.UInt32 := RTT.VR + milliseconds;
   begin
      while  RTT.VR < sleep_unitl loop
         null;
      end loop;
   end sleep_ms;
   
begin
   PIOB.PER.Val := 16#08000000#;
   PIOB.OER.Val := 16#08000000#;   
   RTT.MR.RTPRES := 16#00000020#;
   WDT.MR.WDDIS := True;
   PMC.PMC_PCER0.PID.Val := 16#1#;
   PIOA.PDR.Val := 16#00000300#;
   UART.CR.RSTRX := True;
   UART.CR.RSTTX := True;
   UART.CR.RXDIS := True;
   UART.CR.TXDIS := True;
   UART.MR.PAR := Interfaces.SAM.UART.NO;
   UART.MR.CHMODE := Interfaces.SAM.UART.NORMAL;
   UART.BRGR.CD := 9600;
   UART.CR.RXEN := True;
   UART.CR.TXEN := True;
   
      
   loop
      UART.THR.TXCHR := Interfaces.SAM.Byte(75);
      PIOB.SODR.val := 16#08000000#;
      sleep_ms(50);
      PIOB.CODR.val := 16#08000000#;
      sleep_ms(50);
   end loop;
   
end blink;   

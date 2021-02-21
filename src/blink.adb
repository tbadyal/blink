with system;

procedure blink is   
   
    type Word is mod 2**32;
   
   pb_pio_enable : Word;
   pragma Volatile (pb_pio_enable);
   for pb_pio_enable'Address use System'To_Address(16#400E1000#);

   pb_output_enable : Word;
   pragma Volatile (pb_output_enable);
   for pb_output_enable'Address use System'To_Address(16#400E1010#);

   pb_set_output_data : Word;
   pragma Volatile (pb_set_output_data);
   for pb_set_output_data'Address use System'To_Address(16#400E1030#);

   pb_clear_output_data : Word;
   pragma Volatile (pb_clear_output_data);
   for pb_clear_output_data'Address use System'To_Address(16#400E1034#);
   
   pb27_mask : Word := 16#08000000#;
   
   timer_mode_register : Word;
   pragma Volatile (timer_mode_register);
   for timer_mode_register'Address use System'To_Address(16#400E1A30#);
   
   timer_value_register : Word;
   pragma Volatile (timer_value_register);
   for timer_value_register'Address use System'To_Address(16#400E1A38#);
   
    procedure sleep_ms(milliseconds : Word) is
      sleep_unitl : Word := timer_value_register + milliseconds;
   begin
      while  timer_value_register < sleep_unitl loop
         null;
      end loop;
   end sleep_ms;

   
begin
      
   pb_pio_enable    := pb27_mask;
   pb_output_enable := pb27_mask;
   timer_mode_register := 16#00000020#;
      
   loop
       pb_set_output_data := pb27_mask;
		sleep_ms(100);
		pb_clear_output_data := pb27_mask;
		sleep_ms(100);
         
   end loop;
end blink;   

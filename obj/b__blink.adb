pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__blink.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__blink.adb");
pragma Suppress (Overflow_Check);

package body ada_main is



   procedure adainit is
   begin
      null;

   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_blink");

   procedure main is
      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      adainit;
      Ada_Main_Program;
   end;

--  BEGIN Object file/option list
   --   C:\Users\ADMIN\gpr\blink\obj\blink.o
   --   -LC:\Users\ADMIN\gpr\blink\obj\
   --   -LC:\Users\ADMIN\gpr\blink\obj\
   --   -LC:\gnat\2020-arm-elf\arm-eabi\lib\gnat\zfp-cortex-m3\adalib\
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;

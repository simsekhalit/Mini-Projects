@echo off
setlocal enableextensions enabledelayedexpansion
cd %~dp0
set title=Simpor - Smart Pinger (~)
::configuration
set addr=lux.valve.net
set last_x_packets=1000


:main
echo Pinging server: %addr%
title %title% ^| %addr%
set ping_arr[0]=N/A
set ping_arr[min]=2147483647
set ping_arr[max]=-1
set min=min
set max=max
set sum=0
set loss=0
set max_loss=0
call :create_table
call :run
goto :EOF


:create_table
for /l %%A in (1,1,%last_x_packets%) do (
	call :create_table_ping "%%A"
	call :create_table_display "%%A"
)
goto :EOF


:create_table_ping
::successful ping
for /f "delims== skip=1 tokens=4" %%A in ('ping !addr! -n 1 ^| find "ms"') do (
	set ping_arr[%~1]=%%A
	set ping_arr[%~1]=!ping_arr[%~1]:~1!
	set ping_arr[%~1]=!ping_arr[%~1]:~0,-2!
	if !ping_arr[%~1]! leq !ping_arr[%min%]! set min=%~1
	if !ping_arr[%~1]! geq !ping_arr[%max%]! set max=%~1
	set /a sum+=!ping_arr[%~1]!
	goto :EOF
)
::failure ping
set ping_arr[%~1]=N/A
set /a loss+=1
if %loss% gtr %max_loss% set /a max_loss+=1
goto :EOF


:create_table_display
if %min%==min (
	set display_min=N/A
) else (
	set display_min=!ping_arr[%min%]!
)
if %max%==max (
	set display_max=N/A
) else (
	set display_max=!ping_arr[%max%]!
)
if %sum% neq 0 (
	set /a display_avg=%~1 - !loss!
	set /a display_avg=!sum!/!display_avg!
) else (
	set display_avg=N/A
)
set /a display_loss=100 * !loss! / %~1
cls
echo Min: %display_min% ^| Max: %display_max% ^| Avg: %display_avg% ^| Loss: %loss% out of %~1 (%display_loss%%%) (%max_loss%)
goto :EOF


:run
for /l %%A in (1,1,%last_x_packets%) do (
	call :ping "%%A"
	call :display "%%A"
)
goto run


:ping
if "!ping_arr[%~1]!"=="N/A" (
	set /a loss-=1
) else (
	set /a sum-=!ping_arr[%~1]!
)
::successful ping
for /f "delims== skip=1 tokens=4" %%A in ('ping !addr! -n 1 ^| find "ms"') do (
	set ping_arr[%~1]=%%A
	set ping_arr[%~1]=!ping_arr[%~1]:~1!
	set ping_arr[%~1]=!ping_arr[%~1]:~0,-2!
	if !ping_arr[%~1]! leq !ping_arr[%min%]! (
		set min=%~1
	) else (
		if !min!==%~1 (
			for /l %%A in (1,1,%last_x_packets%) do (
				if !ping_arr[%%A]! lss !ping_arr[%min%]! set min=%%A
			)
		)
	)
	if !ping_arr[%~1]! geq !ping_arr[%max%]! (
		set max=%~1
	) else (
		if !max!==%~1 (
			for /l %%A in (1,1,%last_x_packets%) do (
				if !ping_arr[%%A]! gtr !ping_arr[%max%]! set max=%%A
			)
		)
	)
	set /a sum+=!ping_arr[%~1]!
	goto :EOF
)
::failure ping
set ping_arr[%~1]=N/A
set /a loss+=1
if %loss% gtr %max_loss% set /a max_loss+=1
goto :EOF


:display
if %min%==min (
	set display_min=N/A
) else (
	set display_min=!ping_arr[%min%]!
)
if %max%==max (
	set display_max=N/A
) else (
	set display_max=!ping_arr[%max%]!
)
if %sum% neq 0 (
	set /a display_avg=!last_x_packets! - !loss!
	set /a display_avg=!sum! / !display_avg!
) else (
	set display_avg=N/A
)
set /a display_loss=100 * !loss! / !last_x_packets!
cls
echo Min: %display_min% ^| Max: %display_max% ^| Avg: %display_avg% ^| Loss: %loss% out of %last_x_packets% (!display_loss!%%) (%max_loss%)
goto :EOF


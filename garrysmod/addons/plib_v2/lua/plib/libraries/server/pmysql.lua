-- NOTE:
-- This module depreciated and is just a means of basic backwards compatibility.
-- Require ptmysql or pmysqloo not this module!!

if (system.IsWindows() and file.Exists('lua/bin/gmsv_mysqloo_win32.dll', 'MOD')) or (system.IsLinux() and file.Exists('lua/bin/gmsv_mysqloo_linux.dll', 'MOD')) then
	require('pmysqloo')
	pmysql = pmysqloo
elseif (system.IsWindows() and file.Exists('lua/bin/gmsv_tmysql4_win32.dll', 'MOD')) or (system.IsLinux() and file.Exists('lua/bin/gmsv_tmysql4_linux.dll', 'MOD')) then
	require('ptmysql')
	pmysql = ptmysql
end
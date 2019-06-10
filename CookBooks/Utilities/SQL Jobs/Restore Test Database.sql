USE MASTER
exec dbo.sp_sp_start_job_wait 'TEST - Manual - $(Database) - DB Restore'
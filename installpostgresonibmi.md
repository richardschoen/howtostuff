# Install and configure Postgresql DB Server on IBM i 

// install postgres yum packages from IBMi ACS Open Source Packages

Package list:
postgresql12
postgresql12-contrib
postgresql12-devel
postgresql12-docs
postgresql12-libecpg
postgresql12-libogtypes
postgresql12-libpq
postgresql12-server


// create IBMi user: POSTGRES

// Log in to SSH as IBMi user postgres to do setup

// Start bash shell by typing bash unless bash is alresdy your default shell. 

// Run the following command sequence to initialize postgres database inthe /postgres IFS location

cd /

mkdir postgres

export PGDATA=/postgres

initdb -E UTF-8 -D /postgres

// After initdb you should see the following message:

Success. You can now start the database server using:
    pg_ctl -D /postgres -l logfile start
**** Do not start server yet until modifying /postgres/postgresql.conf *****
	
// use nano editor, vim or other editor to edit /postgres/postgresql.conf file 
// so the server will listen on TCP/IP addresses. 
// Enable access on all addresses

edit /postgres/postgresql.conf
uncomment and change listen_addresses = '*' entry
uncomment port = 5432 entry. 
save postgresql.conf

	
// Run the following command to start postgres database server

pg_ctl -D /postgres -l logfile start

// This command can be used to stop the server

pg_ctl -D /postgres -l logfile stop

// You should see the following messages
waiting for server to start.... done
server started

// From a 5250 session, run WRKACTJOB and you should see the active server jobs 
// and threads in the QUSRWRK subsystem
--------------------------------------------------------------------------------
QP0ZSPWP     POSTGRES    BCI      .0  PGM-postgres     SELW
QP0ZSPWP     POSTGRES    BCI      .0  PGM-postgres     SELW
QP0ZSPWP     POSTGRES    BCI      .0  PGM-postgres     SELW
QP0ZSPWP     POSTGRES    BCI      .0  PGM-postgres     SELW
QP0ZSPWP     POSTGRES    BCI      .0  PGM-postgres     SELW
QP0ZSPWP     POSTGRES    BCI      .0  PGM-postgres     SELW
QP0ZSPWP     POSTGRES    BCI      .0  PGM-postgres     SELW
--------------------------------------------------------------------------------

// From a 5250 session, run "NETSTAT *CNN" to verify the server is listening on port 5432.
// You should see an entry for Local Port 5432 which tells you the server is listening
// for connections. 

--------------------------------------------------------------------------------
                        Work with IPv4 Connection Status                   
                                                             System:   SYS1
 Type options, press Enter.                                                
   3=Enable debug   4=End   5=Display details   6=Disable debug            
   8=Display jobs                                                          
                                                                           
      Remote           Remote     Local                                    
 Opt  Address          Port       Port       Idle Time  State              
      *                *          5432       000:05:22  Listen             
--------------------------------------------------------------------------------

// Allow remote access to server
You can change this by editing /postgres/pg_hba.conf or using the option -A, or

Add following entry:
host   all   all   0.0.0.0/0     password

**Note: This will not enforce passwords. You'll need to review postgres docs for that. 

Save and restart server.

// Create demo postgres database using following command line command

createdb ibmidemo

// psql command utility can be used to provide permissions and do other serder related maintenance. 
// For now we will just allow access for the postgres user to our new database as an example.
// We will also set a password for the postgres user. This samples uses 'postgres2020' for the password. 
// You should use a more secure password. 
// **NOTE: You should also review the Postgres site for appropriate Postgres security measures.

psql 

Type following sql to set database access for postgres database user:

grant all priviliges on database ibmidemo to postgres;

Type following sql to set database server password for postgres database user:

alter user postgres with password 'postgres2020';

type: quit <press enter to exit psql>


// Use Heidi or other Postgres client to connect to Postgres database. 
Host: IBMi host name or IP
Port: 5432
User: postgres
Password: postgres
Database: ibmidemo
 
// Changing port that Postgres server listens on

// use nano editor, vim or other editor to edit /postgres/postgresql.conf file 
// so the server will listen on TCP/IP addresses. 
// Enable access on all addresses

edit /postgres/postgresql.conf

// Change port number. Ex: 605432

port = 60432 
save postgresql.conf

Stop and restart Postgres server

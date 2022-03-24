# cz2007_lab


### Lab 1

For lab 1, let's use https://app.diagrams.net/ for our drawing. Manually upload the .xml file in the Github to the website and push it back to Github when you are done with editing it. 


### Lab 3

Here is the link for our gdocs for this lab https://docs.google.com/document/d/1PONkYb8BckCymqZ5Fbrd42zn6tUQq9dA7Mpfy47jC1U/edit?usp=sharing

### Lab 5

Todo: in the report, we shall mention
1. Why some values are allowed to be NULL
2. (free to add on)

Login Details

（Impt*: ntuVPN needed to connect the server, request the latest GlobalProtect VPN from your school）

Username: DSS2g2

Password: P@ssw0rd!

Server ip addr: 155.69.100.36

Command to check connection:
```sql
SELECT net_transport, auth_scheme, encrypt_option   
FROM sys.dm_exec_connections   
WHERE session_id = @@SPID;
```
Use Visual Studio Code to access MsSQL server
1. Install SQL extensions (search SQL and install the top 2 extensions)
2. Use command "MS SQL: Add Connection" to connect MS server (access DSS2g2 database! not default)
3. Store SQL scripts locally, run them using VS Code and check the result in server

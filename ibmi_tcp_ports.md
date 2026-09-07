# List of common IBM i Host Server Ports for IBM i Access

- Port 446: “the well-known DRDA port” used for Distributed Relational Database Architecture (DRDA) and data source connectivity via JDBC/ODBC, as noted by IBM i Docs. [1] (https://www.ibm.com/docs/en/i/7.5.0?topic=network-ports-port-restrictions), [2] (https://www.ibm.com/docs/en/gdp/11.4.0?topic=tap-installing-s-i), [3] (https://www.reddit.com/r/IBMi/comments/1hv3aco/how_to_get_port_for_ibm_i_db2/)
- Port 447: “the well-known DDM port” used for Distributed Data Management server communication, according to IBM i Docs. [1] (https://www.ibm.com/docs/en/i/7.5.0?topic=network-ports-port-restrictions)
- Port 448: “the well-known TLS port” used for secure, encrypted DDM or DRDA traffic, as stated by IBM i Docs. [1] (https://www.ibm.com/docs/en/i/7.5.0?topic=network-ports-port-restrictions)
- Port 449: “used to look up a service by name and return the port number” for host servers and related functions, as outlined in IBM Support. [1] (https://www.ibm.com/support/pages/tcpip-ports-required-ibm-i-access-and-related-functions)

- Port 8470: as-centralCentral Server: Handles licensing and downloads code page conversion tables.
- Port 8471: as-databaseDatabase Server: Used for Db2 for i database access, SQL queries, and ODBC/JDBC connections.
- Port 8472: as-dtaqData Queue Server: Allows applications to pass data back and forth using IBM i data queues.
- Port 8473: as-fileFile Server: Manages access to the Integrated File System (IFS).
- Port 8474: as-netprtNetwork Print Server: Handles print management and spool files.
- Port 8475: as-rmtcmdRemote Command Server: Runs CL commands and distributed program calls (DPC).
- Port 8476: as-signonSignon Server: Authenticates users, changes passwords, and manages Application Administration.
- Port 8477–8479: ReservedReserved by IBM for future host server allocations.

- Secure Alternatives: If your corporate security policy or PCI compliance requirements prohibit unencrypted traffic, you should block the 8470–8479 range using the ADDTCPPORT command and route your connections through the secure TLS/SSL equivalents (9470–9476): [1] (https://knowledge.broadcom.com/external/article/244959/ibmi-as400-connector-uses-nonssl-port-8.html), [2] (https://www.ibm.com/support/pages/how-disable-tcpip-ports-ibm-i-host-servers), [3] (https://knowledge.broadcom.com/external/article/244959/ibmi-as400-connector-uses-nonssl-port-8.html), [4] (https://www.ibm.com/support/pages/how-configure-ibm-i-host-servers-ssl-only) The alternate secure ports 9470 - 9476 should be used by all applications.



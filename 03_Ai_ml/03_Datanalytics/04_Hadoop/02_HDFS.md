---
title:
  "{ Title }":
tags:
  - ML
  - DA
created:
  "{ date }":
updated:
  "{ date }":
---

```
                     HADOOP ARCHITECTURE (HDFS + YARN)

                           +------------------+
                           |    Client/API    |
                           +---------+--------+
                                     |
                                     v
                     --------------------------------
                     |             MASTER NODES      |
                     --------------------------------

      +-------------------+            +-----------------------+
      |   NameNode        |            |     ResourceManager   |
      | (HDFS Master)     |            |   (YARN Master Node)  |
      +---------+---------+            +-----------+-----------+
                |                                  |
                |                                  |
                v                                  v

   --------------------------------------------------------------
   |                        SLAVE NODES                          |
   --------------------------------------------------------------

   +-------------------+     +-------------------+    +-------------------+
   |   DataNode        |     |   DataNode        |    |   DataNode        |
   | (HDFS Worker)     |     | (HDFS Worker)     |    | (HDFS Worker)     |
   +---------+---------+     +---------+---------+    +---------+---------+
             |                         |                        |
             |                         |                        |
   +---------v---------+     +---------v---------+    +---------v---------+
   | NodeManager       |     | NodeManager       |    | NodeManager       |
   | (YARN Worker)     |     | (YARN Worker)     |    | (YARN Worker)     |
   +---------+---------+     +---------+---------+    +---------+---------+
             |                         |                        |
    +--------v--------+      +---------v--------+     +---------v--------+
    | Containers      |      | Containers       |     | Containers       |
    | (Tasks/Apps)    |      | (Tasks/Apps)     |     | (Tasks/Apps)     |
    +-----------------+      +------------------+     +------------------+

                                   |
                                   v
                           +---------------+
                           |   HDFS Output |
                           +---------------+
```


When a user requests a file, the process is coordinated by two key types of nodes in the Hadoop Distributed File System (HDFS): the NameNode and the DataNodes. 

1. **Request from client:** Your application (the HDFS client) makes a single request to read a file, not to read hundreds of individual blocks.
2. **NameNode gets involved:** The client contacts the NameNode, the "master" that holds all the metadata for the file system. The NameNode looks up which blocks the requested file is composed of and on which DataNodes (slave machines) each block is stored.
3. **NameNode returns metadata:** The NameNode sends the client the locations of the data blocks. Critically, it does not send the data itself, just the "address book" of where to find the data.
4. **Client reads data from DataNodes:** With the block location information, the client bypasses the NameNode and establishes a direct connection to the DataNodes that store the blocks. The client can read blocks from multiple DataNodes in parallel to maximize performance.
5. **Client reassembles the file:** As the client receives the data blocks from the various DataNodes, it automatically pieces them together in the correct sequence to reconstruct the original file. The entire process is transparent to the user, who simply receives the complete file as requested. 

In short, the user makes a simple request, and the HDFS client-server system handles all the complex logic of finding, fetching, and merging the distributed data blocks automatically.
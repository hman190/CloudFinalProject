CloudFinalProject
=================

雲端專題期末報告
至4/20為止，安裝並熟悉使用hadoop

使用Cloudera Manager安裝失敗
1. 完全按照manual的指示
2. 執行到使用選擇cluster進行安裝時失敗
該手冊並未詳述只需要裝一臺時要怎麼解決。由於一定要選擇至少一臺電腦進行cluster安裝，因此選擇了localhost(127.0.0.1)，但連續安裝失敗，因此放棄使用，改以徐承志同學的解決方案
手動安裝hadoop1.0.4
下載CentOS 6.2 x64
環境設定
1. 將/etc/sudoer/將sudo使用者帳號加入其中
#su –
Password:
#visudo /etc/sudoer/ 於文件內搜尋ALL，複製該行並將root改為hman
2. 更新yum
#sudo yum update這步會執行很久
3. 下載jdk 6u33 x64版本 http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-javase6-419409.html#jre-6u33-oth-JPR
(i)      至oracle登入會員
(ii)   	同意使用條款並下載
(iii)  	下載後執行安裝檔
#chomd 777 ./jdk…
#./jdk… 所有詢問都yes
(iv)  	#sudo alternatives –install /usr/bin/java java /usr/java/latest/bin/java 2
        	#sudo alternatives –config java
(v)   	下載後執行java –version以確認正確安裝java
4. 設定~/.bash_profile
#export JAVA_HOME=/usr/java/default/
#export PATH=$JAVA_HOME/bin:$PATH
5. 設定/etc/sysctl.conf
#vm.swappiness = 0
6. 設定/etc/security/limits.conf
#hdfs soft nofile 102642
#hdfs hard nofile 102642
#hbase – nofile 102642
7. 下載並解壓縮hadoop-1.0.4 http://www.apache.org/dist/hadoop/core/hadoop-1.0.4/
#tar –zxvf hadoop-1.0.4.tar.gz
#mv hadoop-1.0.4 /usr/java
8. 設定hadoop之JAVA_HOME
#cd /usr/java/hadoop-1.0.4/conf/
#vi hadoop-env.sh
export JAVA_HOME=’/usr/java/jdk1.6.0_33/’
9. 測試word count
#cd /usr/java/hadoop-1.0.4/
#mkdir input
#cd input
#echo ‘hello world’>test.1.txt
#echo ‘hello hadoop’>test2.txt
#cd ..
#bin/hadoop jar hadoop-example-1.0.4.jar wordcount input outputc
#cat outputc
hello 2
hadoop 1
world 1
10. 設定.xml檔

至4/20起，安裝並使用mahout

Mahout
系統要求0.22以上，不確定1.0.4相不相容
完全按照Hadoop in practice A.20操作
執行9.1之例子，直到
$MAHOUT_HOME/bin/mahout  \
recommenditembased \ -Dmapred.reduce.tasks=10 \
--similarityClassname SIMILARITY_PEARSON_CORRELATION \ --input ratings.csv \ --output item-rec-output \ --tempDir item-rec-tmp \
--usersFile user-ids.txt
為止失敗，無法產生預期結果
 


執行順序及產生結果如下
1. su -
2. hadoop fs -put user-ids.txt ratings.csv
產生結果
Warning: $HADOOP_HOME is deprecated.

13/04/30 20:38:16 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 0 time(s).
13/04/30 20:38:17 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 1 time(s).
13/04/30 20:38:18 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 2 time(s).
13/04/30 20:38:19 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 3 time(s).
13/04/30 20:38:20 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 4 time(s).
13/04/30 20:38:21 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 5 time(s).
13/04/30 20:38:22 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 6 time(s).
13/04/30 20:38:23 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 7 time(s).
13/04/30 20:38:24 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 8 time(s).
13/04/30 20:38:25 INFO ipc.Client: Retrying connect to server: localhost/127.0.0.1:9000. Already tried 9 time(s).
Bad connection to FS. command aborted. exception: Call to localhost/127.0.0.1:9000 failed on connection exception: java.net.ConnectException: Connection refused

Google之後似乎是hadoop namenode的format問題，因此重新format
3. hadoop namenode -format
13/04/30 20:33:39 INFO namenode.NameNode: STARTUP_MSG:
/************************************************************
STARTUP_MSG: Starting NameNode
STARTUP_MSG:   host = localhost.localdomain/127.0.0.1
STARTUP_MSG:   args = [-format]
STARTUP_MSG:   version = 1.0.4
STARTUP_MSG:   build = https://svn.apache.org/repos/asf/hadoop/common/branches/branch-1.0 -r 1393290; compiled by 'hortonfo' on Wed Oct  3 05:13:58 UTC 2012
************************************************************/
Re-format filesystem in /tmp/hadoop-root/dfs/name ? (Y or N) y
Format aborted in /tmp/hadoop-root/dfs/name
13/04/30 20:34:03 INFO namenode.NameNode: SHUTDOWN_MSG:
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at localhost.localdomain/127.0.0.1
************************************************************/
結果還是失敗

以上為期中考前的進度

期中考後主要微研究R上的推薦系統

找到一個library recommenderlab   http://cran.r-project.org/web/packages/recommenderlab/index.html
詳細報告如下 http://tinyurl.com/pwjk7gp
這套library最主要的功能集中在特殊的data structure上，如 RatingMatrix系列，topNList等等
這些特別的結構沒辦法以mapreduce擴充
在嘗試了一段時間後決定放棄，改為自己以實作推薦系統

主要的概念為Cosine similarity。http://en.wikipedia.org/wiki/Cosine_similarity 以及  http://terms.naer.edu.tw/detail/1679004/
先以mapreduce的方式製造出cosine similarity的item-item matrix，並將每個user視為item的各個分量的dimension，preference視為該dimension的量
可以因此算出每個item的相似度，並取餘弦反函數。
接者假設有一使用者有一些對item的評分資料，但並不完整，我們便可利用之前利用的training data建構出一個方陣，利用矩陣乘法
       i1    i2     i3           u1             u1
  i1  pi/4  pi/3   pi/6       i1  0.5     i1  5pi/12
  i2  pi/3  pi/4   pi/12   *  i2  -    =  i2  5pi/24
  i3  pi/6  pi/12  pi/4       i3  0.5     i3  5pi/12
由於完全相同的物品其弳度會是pi/4，故設定一個cutoff將靠近 pi/4 範圍內的弳度皆視為相似，並用以判斷是否要推薦該物品給user

時機操作上遇到建構前述左側之item matrix的問題，卡在利用mapreduce的辦法建構矩陣的部份

另外，此套方法為我自己想到的，在判斷是否該推薦的地方也不太嚴謹

我所使用的data和徐承志同學所使用的來源相同

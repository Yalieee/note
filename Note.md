# PHP5 vs PHP7
- Performance (Better performance and memory usage provided by new engine)
- Return type
- Error handling
- 64 bits support
- New operator (<=>)

# Pros and Cons of hash map
Pros: fast
Cons: possible collision

# Database
## LEFT JOIN (LEFT OUTER JOIN)
擁有所有 table1 的資料
```sql
SELECT column_name(s)
FROM table1
LEFT JOIN table2 ON table1.column_name = table2.column_name;
```

## INNER JOIN
兩個 table 的 `交集`
```py
SELECT column_name(s)
FROM table1
INNER JOIN table2 ON table1.column_name = table2.column_name;
```

## ACID
- Atomicity（原子性）：一個事務（transaction）中的所有操作，或者全部完成，或者全部不完成，不會結束在中間某個環節。事務在執行過程中發生錯誤，會被恢復（Rollback）到事務開始前的狀態，就像這個事務從來沒有執行過一樣。即，事務不可分割、不可約簡:
- Consistency（一致性）：ensures that a transaction can only bring the database from one valid state to another
- Isolation（隔離性）：資料庫允許多個並發事務同時對其數據進行讀寫和修改的能力，隔離性可以防止多個事務並發執行時由於交叉執行而導致數據的不一致。
- Durability（持久性）：事務處理結束後，對數據的修改就是永久的，即便系統故障也不會丟失。

### Isolation
事務隔離分為不同級別
- Serializable: 最高的隔離級別。要求在選定對象上的讀鎖和寫鎖保持直到事務結束後才能釋放。在SELECT 的查詢中使用一個「WHERE」子句來描述一個範圍時應該獲得一個「範圍鎖」（range-locks）。這種機制可以避免phantom reads 現象
- REPEATABLE READS: 基於鎖機制並發控制的DBMS需要對選定對象的 read locks 和 write locks 一直保持到事務結束，但不要求「範圍鎖」，因此可能會發生 phantom reads。
- READ COMMITTED: 基於鎖機制並發控制的DBMS需要對選定對象的寫鎖一直保持到事務結束，但是讀鎖在SELECT操作完成後馬上釋放（因此「不可重複讀」現象可能會發生，見下面描述）。和前一種隔離級別一樣，也不要求「範圍鎖」。
- READ UNCOMMITTED: 最低的隔離級別。允許「髒讀」（dirty reads），事務可以看到其他事務「尚未提交」的修改。

問題
- Phantom reads: 如果交易A進行兩次查詢，在兩次查詢之中有個交易B插入一筆新資料或刪除一筆新資料，第二次查詢時得到的資料多了第一次查詢時所沒有的筆數，或者少了一筆。這是 Non-repeatable reads 的一個情況(專注在 INSERT 造成的數量差)
- - 交易A進行查詢得到五筆資料
- - 交易B插入一筆資料
- - 交易B COMMIT
- - 交易A進行查詢得到六筆資料

- Non-repeatable reads: 在一次事務中，當一行數據獲取兩遍得到不同的結果表示發生了「不可重複讀」。(T1先SELECT一次，T2 COMMIT成功，T1還沒結束再讀一次，就會不一樣)

- Dirty read: 當一個事務允許讀取另外一個事務修改但未提交的數據時，就可能發生髒讀。

# 樂觀鎖 v.s. 悲觀鎖
## 樂觀鎖(Optimistic Concurrency Control, OCC)
总是假设最好的情况，每次去拿数据的时候都认为别人不会修改，所以不会上锁，但是在更新的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号机制和CAS算法实现。

樂觀並行控制多數用於資料爭用不大、衝突較少的環境中，這種環境中，偶爾回復交易的成本會低於讀取資料時鎖定資料的成本，因此可以獲得比其他並行控制方法更高的吞吐量。

## 悲觀鎖 (Pessimistic Concurrency Control, PCC)
总是假设最坏的情况，每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，这样别人想拿这个数据就会阻塞直到它拿到锁（共享资源每次只给一个线程使用，其它线程阻塞，用完后再把资源转让给其它线程）。传统的关系型数据库里边就用到了很多这种锁机制，比如行锁，表锁等，读锁，写锁等，都是在做操作之前先上锁。Java中synchronized和ReentrantLock等独占锁就是悲观锁思想的实现。

# Prepared statement
如果同樣的 Prepared statement 重複執行，因為有 cache 機制的關係，且 Sql server 只會驗證及編譯一次，因次會有比較好的效能(即使是不同的 data)。

# Two Phase Locking
分成兩個階段
- Phase1: 在此階段中，允許加入新的鎖定或升級動作，但不允許解除任何鎖
- Phase2: 在此階段中，允許解除現存鎖定或降級動作，但不允許加入任何新的鎖

會產生的問題
- Dead lock
- Starvation

# Dead lock
交易必須滿足下列四個條件，「死結」才會發生：

– 「彼此互斥」(Mutual Exclusion)
– 「鎖定且等待」(Lock and Wait)
– 「不得強佔」(No Preemption)
– 「循環等待」(Cyclic Waits)

# Deadlock Detection
「死結偵測」通常使用「等待圖」(Wait-for Graph) 進行檢查正在等待的交易是否形成一個迴圈，如果迴圈存在，表示這些正在等待的交易會發生死結，那麼系統會選擇其中一個交易當作犧牲者 (Victim)，強迫該交易進行撤回 (Rollback) 動作，並重新開始執行。

# Deadlock Prevention
- 交易在開始執行之前，就必須先將所有需要的資料予以「鎖定」才可以執行交易
- Transaction Timestamp (wait-die, wound-wait)

## Wait-die
如果 T1 比 T2 早執行，T1 如果需要 T2 lock 的資源，可以等 T2。相對之下，T2 如果要用 T1 lock 的資源，T2 必須馬上自殺，之後再以相同的交易時間戳記重新啟動執行

## Wound-wait
如果 T1 比 T2 早執行，T1 如果需要 T2 lock 的資源，T2 必須馬上自殺，之後再以相同的交易時間戳記重新啟動執行，相反的，假設 T2 要使用 T1 已經鎖定的資料時，則 T2 必須繼續等。

# Primary Index
 primary index is an index on a set of fields that includes the unique primary key for the field and is guaranteed not to contain duplicates. Also Called a Clustered index. eg. Employee ID can be Example of it.

# Secondary Index
A Secondary index is an index that is not a primary index and may have duplicates. eg. Employee name can be example of it. Because Employee name can have similar values.

The primary index contains the key fields of the table. The primary index is automatically created in the database when the table is activated. If a large table is frequently accessed such that it is not possible to apply primary index sorting, you should create secondary indexes for the table.

The indexes on a table have a three-character index ID. '0' is reserved for the primary index. Customers can create their own indexes on SAP tables; their IDs must begin with Y or Z.

# Multithread v.s. Multiprocess
- Multithread 死掉會全死
- Mutlithread 會有 lock 問題
- Mutlithread 之間可以共享資源，Multiprocess 之間需要用 IPC 溝通
- 記憶體/資源消耗: Multiprocess > Multithread (Multithread 共用 code)
- Windows 的 Process 比較貴，所以比較常見 Multithread。Unix 系統的 Process 比較便宜，比較常見 Multiprocess

# Zombie process
殭屍進程是指完成執行（通過exit系統調用，或運行時發生致命錯誤或收到終止信號所致）但在作業系統的進程表中仍然有一個表項（進程控制塊PCB），處於"終止狀態"的進程。這發生於子進程需要保留表項以允許其父進程讀取子進程的exit status：一旦退出態通過wait系統調用讀取，殭屍進程條目就從進程表中刪除，稱之為"回收（reaped）"。正常情況下，進程直接被其父進程wait並由系統回收。進程長時間保持殭屍狀態一般是錯誤的並導致資源泄漏。

防止的方法:
- 呼叫 wait
- parent 設定忽略 SIGCHLD 訊號，這樣 child 結束後會直接被回收
- parent 接收到 SIGCHLD 後呼叫 wait

# HTTPS
1. Server has a certificate
2. Use asymmetric encryption to exchange a symmetric cipher
3. Use symmetric cipher for data

## Asymmetric encryption
1. Client HELLO
2. Server responds with certificate (including public key)
3. Client verify digital signature
4. Client generate a cipher, use server's public key to encrypt
5. Server decrypt, get the cipher.
6. Client uses cipher to encrypt a message

# HTTP/2
- HTTP header compression
- Support server push
- Pipelining of requests (免除多次 TCP handshake)
- Multiplexing multiple requests over a single TCP connection

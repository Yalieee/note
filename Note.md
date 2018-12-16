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
- Dirty read: 當一個事務允許讀取另外一個事務修改但未提交的數據時，就可能發生髒讀。
- Phantom reads: 在事務執行過程中，當兩個完全相同的查詢語句執行得到不同的結果集
- Non-repeatable reads: 在一次事務中，當一行數據獲取兩遍得到不同的結果表示發生了「不可重複讀」。(T1先SELECT一次，T2 COMMIT成功，T1還沒結束再讀一次，就會不一樣)

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

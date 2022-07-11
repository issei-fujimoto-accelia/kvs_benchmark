# readme

## run benchmark

run db

```
$ cd redis/
$ sh run.sh

1:C 11 Jul 2022 06:24:54.342 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 11 Jul 2022 06:24:54.342 # Redis version=7.0.2, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 11 Jul 2022 06:24:54.342 # Configuration loaded
1:M 11 Jul 2022 06:24:54.342 * monotonic clock: POSIX clock_gettime
1:M 11 Jul 2022 06:24:54.343 * Running mode=standalone, port=6379.
1:M 11 Jul 2022 06:24:54.343 # Server initialized
...
```


run memtier_benchmark
```
cd memtier_benchmark/
sh run.sh {docker-container-id} redis

172.17.0.2 6379
Json file /outputs/redis.json created...
Writing results to /outputs/redis.txt...
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 5%, 168 secs]  4 threads:     2632406 ops,   16884 (avg:   15649) ops/sec, 637.87KB/sec (avg: 592.03KB/sec), 11.86 (avg: 1962.50) msec latencyncy
...
```


# summary
## memcached 
### type
文字列を保存
(redisに比べてオーバーヘッドが少ない)

### 構成
マルチマスター
レプリケーションできないので、マスター間でデータの不整合が起きる可能性がある

### 分散処理
キーごとにサーバーを使い分ける
サーバー自体では分散機能は持たず、クライアントライブラリ側で実装する必要がある

### 永続化
cacheとしての利用がメイン
永続化についてはあまり触れられていない

### 自動削除
設定した容量を超えると利用されないキャッシュから順番に消える(LRU)。




## redis
### type
String, List, Set, Hash...

https://redis.io/docs/manual/data-types/

### 構成
マスター/スレーブ構成
https://www.sraoss.co.jp/tech-blog/redis/redis-ha/


### 永続化可能
https://www.sraoss.co.jp/tech-blog/redis/redis-persistdata/

### 
シングルスレッド(排他制御)
コア分スケールアウト可能

### 自動削除
いくつかポリシーが選択できる
https://redis-documentasion-japanese.readthedocs.io/ja/latest/topics/lru-cache.html



## Dragonfly
https://dragonflydb.io/platform/

基本redis互換。この辺が使える
https://github.com/dragonflydb/dragonfly#configuration


https://zenn.dev/quiver/articles/0fdc22e9076551


### type
一部redis互換

### 構成
レプリケーション未対応
クラスタなし

### 永続化
?

### 自動削除
LRFU eviction

## まとめ
パフォーマンスだけで言うならDragonflyで良さそう。
サポートとか機能でいうとredisがあんぱい。

redisに比べてmemcachedのほうが、シンプルでメモリの使用率が良さそう。
ただし、redisだとレプリケーションやデータの永続化も行える。
はじめはmemcachedで、redisに切り替えるパターンも想定できるが、
memcachedからredisへの移行はだるいらしい


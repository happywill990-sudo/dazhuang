# 文件桥

用于三条与大壮在飞书 bot-to-bot 不稳定时的兜底互通。

## 目录

- `santiao_to_dazhuang.jsonl`：三条 -> 大壮
- `dazhuang_to_santiao.jsonl`：大壮 -> 三条

## 格式

每行一条 JSON：

```json
{"id":"msg-001","from":"santiao","to":"dazhuang","ts":"2026-03-22T17:57:00+08:00","text":"检查 xxx"}
```

字段约定：
- `id`：消息唯一 ID，避免重复处理
- `from`：发送方，固定 `santiao` 或 `dazhuang`
- `to`：接收方，固定 `dazhuang` 或 `santiao`
- `ts`：ISO 8601 时间戳
- `text`：正文
- `reply_to`：可选，回复哪条消息
- `type`：可选，如 `task` / `reply` / `status`

## 最小流程

### 三条发给大壮
往 `santiao_to_dazhuang.jsonl` 追加一行：

```json
{"id":"st-001","from":"santiao","to":"dazhuang","ts":"2026-03-22T18:00:00+08:00","type":"task","text":"检查飞书互通问题"}
```

### 大壮回三条
往 `dazhuang_to_santiao.jsonl` 追加一行：

```json
{"id":"dz-001","from":"dazhuang","to":"santiao","ts":"2026-03-22T18:01:00+08:00","type":"reply","reply_to":"st-001","text":"已收到，开始排查"}
```

## 注意

- 采用 JSONL，便于追加写入
- 先保证单写单读，避免并发覆盖
- 如需自动轮询，可后续再加 watcher 脚本

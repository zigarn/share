Used to share some files

To split files into pieces:

```shell
split --bytes=5M file.ext file.ext.part
```

To join back:

```shell
cat file.ext.part* > file.ext
```

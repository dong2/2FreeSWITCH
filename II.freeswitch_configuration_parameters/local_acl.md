### acl
```
局域网支持

1) 
conf/autoload_configs/acl.conf.xml 中，加入下面配置：

<list name="localnet.auto" default="allow">
</list>

2)
然后，conf/sip_profiles/internal.xml 中加入下列配置：

<param name="apply-candidate-acl" value="localnet.auto"/>
```

https://blog.csdn.net/foruok/article/details/74287842

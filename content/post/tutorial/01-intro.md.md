+++
draft = "true"
+++

```
digraph Q {
   node [shape=record];
   controller [ shape=ellipse]
   kafka1 [shape=box3d]
   kafka2 [shape=box3d]
   kafka3 [shape=box3d]
   subgraph cluster_kafka {
      label= <<table border="0" width="100%"><tr><td align="left">kafka</td><td port="k0"></td><td></td></tr></table>>;
      {rank=same kafka1 kafka2 kafka3}
      kafka1 -> kafka2 -> kafka3 [color=grey arrowhead=none];
   }
   controller -> kafka2
}
```



-->


> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTM2ODMxNjkyNCwtMzY4ODI5NDc0XX0=
-->
# Web_tasks
## 1、FirstUniChar
通过字符的ASCII值来对字符串中的每个字符进行统计出现次数，因为默认只有小写字母，所以用于记录出现次数的数组大小为26。  
```
for(i = 0; i < str.length(); i++){
    hashValue[str.charAt(i) - 'a']++;
}
for(i = 0; i < str.length(); i++){
    if(hashValue[str.charAt(i) - 'a'] == 1){
        return i;
    }
}
```
这段代码使用字符串的charAt（）方法来获取字符串中的每个字符，通过`str.charAt(i)-'a'`来找到字符的存储的位置。  
之后通过查看hashValue数组存储的值，找到第一个出现次数为1的字符，并返回其下标，不再继续寻找。  
## 2、Odd_Even_List
通过指向单链表结点的指针来标记奇数与偶数范围。
`even_head, even_rear`这两个指针标记已固定的偶数结点范围，`odd_rear`用来标记已固定的最后一个奇数结点，`odd_target`标记待转移的奇数结点。  
```
odd_target = even_rear->next;
if(odd_target == NULL){
    break;
}
odd_rear->next = odd_target;
even_rear->next = odd_target->next;
odd_target->next = even_head;
odd_rear = odd_target;
```
这段代码判断待转移的奇数结点是否为空，不为空则将待转移奇数结点转移到已固定的奇数结点后面，并将其设置为最后的已固定奇数结点。  
```
if(even_rear->next == NULL){
    return;
}
even_rear = even_rear->next;
```
这段代码判断转移后的单链表中，已固定的偶数结点范围后面的**因为奇数结点的转移而变成在已固定的最后的偶数结点的后面的未固定偶数结点**是否为空，如果不为空，则扩大已固定偶数结点的范围。
  
重复以上步骤直到出现NULL指针，便将奇数结点全部移动偶数结点前面。
## 3、ArraySort
通过shell排序对给定数组进行从小到大排序。  
通过以下代码获得数组元素用于排序的值：
```
    private static int getValue(Object obj){
        if(obj instanceof Integer){
            return (int)(Integer)obj;
        }
        if(obj instanceof Character){
            return (int)(Character)obj;
        }
        if(obj instanceof String){
            return (int)obj.toString().charAt(0);
        }
        return 0;
    }
```
这个方法对输入的Object对象进行判断，整数返回整数值，字符返回ASCII值，字符串返回字符串第一个字符的ASCII值。
```
    private static void sortArray_shell(Object[] objects, int d){
        int i,j,inc;
        Object temp;
        for(inc = d; inc > 0; inc /= 2){
            for(i = inc; i < objects.length; i++){
                temp = objects[i];
                for(j = i - inc; j >= 0 && (getValue(temp) < getValue(objects[j])); j -= inc){
                    objects[j + inc] = objects[j];
                }
                objects[j + inc] = temp;
            }
        }
    }
```
这个方法为shell排序的具体实现。  
最后将给定数组以及排序后的数组输出。

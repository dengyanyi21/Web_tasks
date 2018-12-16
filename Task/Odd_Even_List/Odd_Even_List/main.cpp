//
//  main.cpp
//  Odd_Even_List
//
//  Created by DYY on 2018/7/7.
//  Copyright © 2018年 DYY. All rights reserved.
//

#include <iostream>
using namespace std;

struct Node;
typedef Node* PNode;
struct Node{
    int info;
    PNode next;
};
struct LinkList{
    PNode head;
    PNode rear;
};
typedef LinkList* PLinkList;

PLinkList createNullLinkList(){
    PLinkList pll = (PLinkList)malloc(sizeof(LinkList));
    if(pll != NULL){
        pll->head = NULL;
        pll->rear = NULL;
    }else{
        printf("Out of space!\n");
    }
    return pll;
}

void add_Node(PLinkList pll, int value){
    PNode q = (PNode)malloc(sizeof(Node));
    if(q == NULL){
        printf("Out of space!\n");
        return;
    }else{
        q->info = value;
        q->next = NULL;
        if(pll->head == NULL){
            pll->head = q;
            pll->rear = q;
        }else{
            pll->rear->next = q;
            pll->rear = q;
        }
    }
}

void displayList(PLinkList pll){
    PNode q = pll->head;
    while (q != NULL) {
        printf("%d->",q->info);
        q = q->next;
    }
    printf("NULL\n");
}

void changeList(PLinkList pll){
    PNode odd_target, odd_rear, even_head, even_rear;
    odd_rear = pll->head;
    if(odd_rear == NULL || odd_rear->next == NULL){
        return;
    }
    even_head = odd_rear->next;
    even_rear = even_head;
    while (true) {
        odd_target = even_rear->next;
        if(odd_target == NULL){
            break;
        }
        odd_rear->next = odd_target;
        even_rear->next = odd_target->next;
        odd_target->next = even_head;
        odd_rear = odd_target;
        if(even_rear->next == NULL){
            return;
        }
        even_rear = even_rear->next;
    }
}

int main(){
    int n,tempInt;
    PLinkList pll = createNullLinkList();
    printf("请输入单链表的结点个数：");
    scanf("%d",&n);
    if(n <= 0){
        return 0;
    }
    printf("输入每个结点的结点值:\n");
    for(int i = 0; i < n; i++){
        scanf("%d",&tempInt);
        add_Node(pll, tempInt);
    }
    printf("\n输入单链表：");
    displayList(pll);
    changeList(pll);
    printf("输出单链表：");
    displayList(pll);
    return 1;
}

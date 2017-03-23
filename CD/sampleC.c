#include<stdio.h>
char names[1000][1000];
char temp[1000];

int func(int a,int b)
{
	return 5;
}

void main()
{
/*This
is a
multline comment*/
	char s="awdhwj";
	int n=10,i=2,c=3;
	func(n,i);
	n = n + i;
	scanf("%d", &n);
	int f;
	func(f,i);
	for(i = 1; i <= n; i++)
	{
		scanf("%s", names[i]);
	}
	int j;
	do
	{
		j = i + 1;
	}while(j <= n);


	for(i = 1; i <= n; i++)
	{
		printf("%s ", names[i]);
	}
}

#include<stdio.h>
#include<string.h>

char names[1000][1000];
char temp[1000];
29th Feb 2015
void main()
{
/*This
is a
multline comment*/
	int 9d;
	char s="awdhwj;
	int n,i;
	scanf("%d", &n);
	for(i = 1; i <= n; i++)
		scanf("%s", names[i]);
	
	i = 1;
	int j;
	
	do
	{
		int mini = i;
		j = i + 1;
		do
		{
			if(j <= n)
			{
				if(strcmp(names[mini], names[j]) > 0)
				{
					mini = j;
				}
			}
			j++;
			
		}while(j <= n);
		
		strcpy(temp, names[mini]);
		strcpy(names[mini], names[i]);
		strcpy(names[i], temp);
		
		i++;
		
	}while(i <= n);

	for(i = 1; i <= n; i++)
		printf("%s ", names[i]);
}

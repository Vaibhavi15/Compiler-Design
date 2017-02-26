#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/* maximum size of hash table */
#define SIZE 200 
#define MAXTOKENLEN 40

/* power of two multiplier in hash function */
#define SHIFT 4

/* the hash function */
static int hashc ( char * key )
{ int temp = 0;
  int i = 0;
  while (key[i] != '\0')
  { temp = ((temp << SHIFT) + key[i]) % SIZE;
    ++i;
  }
  return temp;
}

/* a linked list of references (line nos) for each variable */
typedef struct RefListRecc { 
     int lineno;
     struct RefListRecc * next;
     /* ADDED */
     int type;
} * RefListc;


/* hash entry holds variable name and its reference list */
typedef struct HashRecc { 
     char st_name[MAXTOKENLEN];
     int st_size;
     RefListc lines;
     int st_value;
     /* ADDED */
     int st_type;
     int st_token;
     struct HashRecc * next;
} * Nodec;

/* the hash table */
static Nodec hashTablec[SIZE];

 /* insert an entry with its line number - if entry
  *  already exists just add its reference line no.  
  */
void insertc( char * name, int len, int type, int lineno )
{ 
  /* ADDED */
  /*int len = strlen(name);*/
  int h = hashc(name);
  Nodec l =  hashTablec[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) /* variable not yet in table */
  { l = (Nodec) malloc(sizeof(struct HashRec));
    strncpy(l->st_name, name, len);  
    /* ADDED */
    l->st_type = type;
    
    l->lines = (RefListc) malloc(sizeof(struct RefListRec));
    l->lines->lineno = lineno;
    l->lines->next = NULL;
    l->next = hashTablec[h];
    hashTablec[h] = l; }
  else /* found in table, so just add line number */
  { RefListc t = l->lines;
    while (t->next != NULL) t = t->next;
    t->next = (RefListc) malloc(sizeof(struct RefListRecc));
    t->next->lineno = lineno;
    t->next->next = NULL;
  }
} 

/* return value (address) of symbol if found or -1 if not found */
int lookupc ( char * name )
{ int h = hashc(name);
  Nodec l =  hashTablec[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) return -1;
  else return l->st_value;
}

/* return type value of symbol or -1 if symbol not found */
int lookupTypec( char * name )
{
  int h = hashc(name);
  Nodec l =  hashTablec[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) return -1;
  else return l->st_type;
}

/* set datatype of symbol returns 0 if symbol not found */
int setTypec( char * name, int t )
{
   int h = hashc(name);
   Nodec l =  hashTablec[h];
   while ((l != NULL) && (strcmp(name,l->st_name) != 0))
     l = l->next;
   if (l == NULL) return -1;
   else {
     l->st_type = t;
     return 0;
   }
}

/* print to stdout by default */ 
void symtab_dumpc(FILE * of) {  
  int i;
  fprintf(of,"------------ ----------  -------------\n");
  fprintf(of,"Values          Type      Line Number\n");
  fprintf(of,"------------ ----------  ------------\n");
  for (i=0; i < SIZE; ++i)
  { if (hashTablec[i] != NULL)
    { Nodec l = hashTablec[i];
      while (l != NULL)
      { RefListc t = l->lines;
        fprintf(of,"%-12s ",l->st_name);

	

        if (l->st_type == 1)
           fprintf(of,"%-13s","Integer");
        if (l->st_type == 2)
           fprintf(of,"%-13s","Float");
        if (l->st_type == 3)
           fprintf(of,"%-7s","Character");

        if (l->st_type == 4)
           fprintf(of,"%-13s","String");


        while (t != NULL)
        { fprintf(of,"%d ",t->lineno);
          t = t->next;
        }
        fprintf(of,"\n");
        l = l->next;
      }
    }
  }
} 

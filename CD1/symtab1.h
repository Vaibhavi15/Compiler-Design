#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/* maximum size of hash table */
#define SIZE 200
#define MAXTOKENLEN 40

/* power of two multiplier in hash function */
#define SHIFT 4

/* the hash function */
static int hash ( char * key )
{ int temp = 0;
  int i = 0;
  while (key[i] != '\0')
  {
    temp = ((temp << SHIFT) + key[i]) % SIZE;
    ++i;
  }
  return temp;
}

/* a linked list of references (line nos) for each variable */
typedef struct RefListRec {
     int lineno;
     struct RefListRec * next;
     /* ADDED */
     int type;
} * RefList;


/* hash entry holds variable name and its reference list */
typedef struct HashRec {
     char st_name[MAXTOKENLEN];
     int st_size;
     RefList lines;
     int st_value;
     /* ADDED */
     int st_type;
     int st_token;
     struct HashRec * next;
} * Node;

/* the hash table */
static Node hashTable[SIZE];

 /* insert an entry with its line number - if entry
  *  already exists just add its reference line no.
  */
void insert( char * name, int len, int token, int type, int lineno )
{
  /* ADDED */
  /*int len = strlen(name);*/
  int h = hash(name);
  Node l =  hashTable[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) /* variable not yet in table */
  { l = (Node) malloc(sizeof(struct HashRec));
    strncpy(l->st_name, name, len);
    /* ADDED */
    l->st_type = type;
    l->st_token = token;
    l->lines = (RefList) malloc(sizeof(struct RefListRec));
    l->lines->lineno = lineno;
    l->lines->next = NULL;
    l->next = hashTable[h];
    hashTable[h] = l; }
  else /* found in table, so just add line number */
  { RefList t = l->lines;
    while (t->next != NULL) t = t->next;
    t->next = (RefList) malloc(sizeof(struct RefListRec));
    t->next->lineno = lineno;
    t->next->next = NULL;
  }
}

/* return value (address) of symbol if found or -1 if not found */
int lookup ( char * name )
{ int h = hash(name);
  Node l =  hashTable[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) return -1;
  else return l->st_value;
}

/* return type value of symbol or -1 if symbol not found */
int lookupType( char * name )
{
  int h = hash(name);
  Node l =  hashTable[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) return -1;
  else return l->st_type;
}

/* set datatype of symbol returns 0 if symbol not found */
int setType( char * name, int t )
{
   int h = hash(name);
   Node l =  hashTable[h];
   while ((l != NULL) && (strcmp(name,l->st_name) != 0))
     l = l->next;
   if (l == NULL) return -1;
   else {
     l->st_type = t;
     return 0;
   }
}

/* print to stdout by default */
void symtab_dump(FILE * of) {
  int i;
  fprintf(of,"------------ ------------ ---------- -----------\n");
  fprintf(of,"Name         Token Class   Type      Line Number\n");
  fprintf(of,"------------ ------------ ---------- -----------\n");
  for (i=0; i < SIZE; ++i)
  { if (hashTable[i] != NULL)
    { Node l = hashTable[i];
      while (l != NULL)
      { RefList t = l->lines;
        fprintf(of,"%-12s ",l->st_name);

	if (l->st_token ==1)
	   fprintf(of,"%-13s","Keyword");
	if (l->st_token ==2)
	   fprintf(of,"%-13s","Identifier");
        if (l->st_token ==3)
	   fprintf(of,"%-13s","Operator");
        if (l->st_token ==4)
	   fprintf(of,"%-13s","Punctuator");

     if (l->st_token ==5)
  fprintf(of,"%-13s","Function");
  if (l->st_token ==6)
fprintf(of,"%-13s","Constants");

        if (l->st_type == 0)
           fprintf(of,"%-17s","    -    ");
        if (l->st_type == 1)
           fprintf(of,"%-17s","Unknown  ");
        if (l->st_type == 2)
           fprintf(of,"%-17s","int  ");
        if (l->st_type == 3)
                 fprintf(of,"%-17s","char  ");
         if (l->st_type == 4)
                  fprintf(of,"%-17s","char array ");
        if (l->st_type == 5)
                 fprintf(of,"%-17s","2d char array ");



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

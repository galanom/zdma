#pragma once
void zoled_refresh(void);
void zoled_move(int r, int c);
void zoled_addch(char ch);
void zoled_mvaddch(int r, int c, char ch);
void zoled_addstr(char *s);
void zoled_print(char *s, ...);
void zoled_mvprint(int r, int c, char *s, ...);
void zoled_clrln(int r);
void zoled_clrscr(void);
void zoled_disable(void);
void zoled_enable(void);


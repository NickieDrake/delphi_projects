program ��7_2_10��������;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  tmas = array [1 .. 32] of string;
  tmasvowels = array [1 .. 10] of string;
  trussian = array [1 .. 33] of string;

const
  prefix: tmas = ('��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '���', '���', '���', '���', '���', '���', '���', '���',
    '���', '���', '���', '���', '���', '���', '���', '���', '�����',
    '�����', '�����');
  vowels: tmasvowels = ('�', '�', '�', '�', '�', '�', '�', '�', '�', '�');
  russian: trussian = ('�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�');

var
  word, wordpref: string;
  i, j, k, count: integer;
  flag, fg1, fg2, fg3, fgvow: boolean;

begin
  writeln('1 russian word:');
  readln(word);
  while (length(word) > 0) and (word[1] = ' ') do
    delete(word, 1, 1);

  if length(word) = 0 then
    writeln('the string is empty')
  else
    begin
      flag := false;
      i := 1;
      while i <= length(word) do
        begin
          while word[i] <> ' ' do
            inc(i);
          inc(i);
          while (word[i] = ' ') do
            delete(word, i, 1);
        end;

      i := 1;
      while (i <= (length(word) - 1)) and (flag = false) do
        begin
          if (word[i] = ' ') and (word[i + 1] <> ' ') then
            flag := true;
          inc(i);
        end;

      if flag = true then
        writeln('there are more then 1 word')
      else
        begin
          count := 0;
          j := 1;
          while (j <= 33) do
            begin
              k := 1;
              while (k <= length(word)) do
                begin
                  if ansilowercase(word[k]) = russian[j] then
                    count := count + 1;
                  inc(k);
                end;
              inc(j);
            end;

          if count <> length(word) then
            writeln('not a russian word')
          else
            begin

              flag := false;
              wordpref := copy(word, 1, 2);
              j := 1;
              while (j <= 13) and (flag = false) do
                begin
                  if (ansilowercase(wordpref) = prefix[j]) then
                    begin
                      if ansilowercase(word[3]) = '�' then
                        insert('-', word, 4)
                      else
                        insert('-', word, 3);
                      flag := true;
                    end;
                  inc(j);
                end;

              if flag = false then
                begin
                  wordpref := copy(word, 1, 3);
                  j := 14;
                  while (j <= 29) and (flag = false) do
                    begin
                      if (ansilowercase(wordpref) = prefix[j]) then
                        begin
                          if ansilowercase(word[4]) = '�' then
                            insert('-', word, 5)
                          else
                            insert('-', word, 4);
                          flag := true;
                        end;
                      inc(j);
                    end;
                end;

              if flag = false then
                begin
                  wordpref := copy(word, 1, 5);
                  j := 30;
                  while (j <= 32) and (flag = false) do
                    begin
                      if (ansilowercase(wordpref) = prefix[j]) then
                        begin
                          if ansilowercase(word[6]) = '�' then
                            insert('-', word, 7)
                          else
                            insert('-', word, 6);
                          flag := true;
                        end;
                      inc(j);
                    end;
                end;

              i := lastdelimiter('-', word) + 1;
              while i <= length(word) do
                begin
                  flag := false;

                  fg1 := false;
                  fg2 := false;
                  fg3 := false;
                  fgvow := false;
                  if (length(word) - i + 1) >= 4 then
                    begin
                      for j := 1 to 10 do
                        begin
                          if ansilowercase(word[i]) = vowels[j] then
                            fg3 := true;
                          if ansilowercase(word[i + 1]) = vowels[j] then
                            fg1 := true;
                          if (ansilowercase(word[i + 2]) = vowels[j]) or
                            (ansilowercase(word[i + 2]) = '�') then
                            fg2 := true;
                          if ((ansilowercase(word[i + 2]) = '�') and
                            (ansilowercase(word[i + 3]) = vowels[j])) or
                            (ansilowercase(word[i + 2]) <> '�') then
                            fgvow := true;
                        end;

                      if (fg1 = true) and (fg2 = true) and (fg3 = false) and
                        (fgvow = true) then
                        begin
                          if ansilowercase(word[i + 2]) <> '�' then
                            insert('-', word, i + 2)
                          else
                            insert('-', word, i + 3);

                          i := lastdelimiter('-', word) + 1;
                          flag := true;
                        end;
                    end;

                  fg1 := true;
                  fg2 := true;
                  fg3 := true;
                  fgvow := false;
                  if (length(word) - i + 1) >= 4 then
                    begin
                      for j := 1 to 10 do
                        begin
                          if ansilowercase(word[i]) = vowels[j] then
                            fg3 := false;
                          if ansilowercase(word[i + 1]) = vowels[j] then
                            fg1 := false;
                          if (ansilowercase(word[i + 2]) = vowels[j]) then
                            fg2 := false;
                          if (((ansilowercase(word[i + 2]) = '�') or
                            (ansilowercase(word[i + 2]) = '�')) and
                            (ansilowercase(word[i + 3]) = vowels[j])) then
                            fg3 := true;
                          for k := (i + 3) to length(word) do
                            begin
                              if ansilowercase(word[k]) = vowels[j] then
                                fgvow := true;
                            end;
                        end;

                      if (fg1 = true) and (fg2 = true) and (fg3 = false) and
                        (fgvow = true) then
                        begin
                          if (ansilowercase(word[i + 2]) <> '�') and
                            (ansilowercase(word[i + 2]) <> '�') then
                            insert('-', word, i + 2)
                          else
                            insert('-', word, i + 3);

                          i := lastdelimiter('-', word) + 1;
                          flag := true;
                        end;
                    end;

                  fg1 := false;
                  fg2 := false;
                  fg3 := false;
                  fgvow := false;
                  if (length(word) - i + 1) >= 4 then
                    begin
                      for j := 1 to 10 do
                        begin
                          if ansilowercase(word[i + 1]) = vowels[j] then
                            fg1 := true;
                          for k := (i + 2) to length(word) do
                            begin
                              if ansilowercase(word[k]) = vowels[j] then
                                fgvow := true;
                            end;
                          if (ansilowercase(word[i + 2]) = vowels[j]) then
                            fg2 := true;
                          if (ansilowercase(word[i + 3]) = vowels[j]) or
                            (((ansilowercase(word[i + 3]) = '�') or
                            (ansilowercase(word[i + 3]) = '�')) and
                            (ansilowercase(word[i + 4]) = vowels[j])) then
                            fg3 := true;

                        end;

                      if (fg2 = false) and (fg3 = false) then
                        fg3 := false
                      else
                        fg3 := true;

                      if (fg1 = true) and (fg3 = true) and (fgvow = true) and
                        (word[i + 2] <> '-') then
                        begin
                          if (ansilowercase(word[i + 3]) = '�') then
                            insert('-', word, i + 4)
                          else
                            insert('-', word, i + 2);
                          i := lastdelimiter('-', word) + 1;
                          flag := true;
                        end;
                    end;

                  if flag = false then
                    inc(i);

                end;
              writeln;
              writeln('Final: ', word);
            end;
        end;
    end;
  readln;

end.

$aux_dir = 'latexmk_files/';
$out_dir = 'latexmk_files/';
$pdflatex ='pdflatex -synctex=1  --enable-pipes --shell-escape';
#$pdf_previewer = "zathura -s -x 'vim +%{line} %{input}' -l error"
#$pdf_previewer = '/usr/bin/zathura -l error -s -x "vim --servername TEX --remote-command %{line}G"';
$pdf_previewer = "/usr/bin/zathura -l error -x 'vim --servername TEX --remote +%{line} \"%{input}\"' %O %S" 

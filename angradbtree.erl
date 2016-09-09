-module(angradbtree).
-compile(export_all).

%	Função que salva um documento no arquivo de documentos. Recebe como parâmetro: *parâmetros* . Retorna: *retorno*.
%	A function that saves a document in the document's file. Receives as attribute: *attribute*. Returns: *return value*. The document is received already in binary form and just has to be saved.  q
create_doc(SizeInBytes, SizeVersion, Doc, DBName) -> 
	{ok, Fp} = file:open(DBName, [write, append]),
	{ok, Pos} = file:position(Fp, cur),
	RawDocSize = byte_size(Doc),
	SizeBin = <<RawDocSize:SizeInBytes/unit:8>>, % The Size is multiplied by 8 to obtain the value in bits.
	Version = <<1:SizeVersion/unit:8>>, % Version is a 2 bytes integer, refering to the times that the doc was changed. "1" means first version. The Size is multiplied by 8 to obtain the value in bits.
	PointerLastDoc = <<-1:4/unit:8>>
	file:write(Fp, <<SizeBin/binary, Version/binary, Doc/binary, PointerLastDoc/binary>>),
	file:close(Fp),
	{ok, Pos}. % LEMBRAR DE QUE A PRIMEIRA VERSÃO DEVE SER COLOCADA NO ARQUIVO SUPERIOR!

%	Função que lê um documento do arquivo de documentos. Recebe como parâmetro: *parâmetros* . Retorna: *retorno*.
%	A function that reads a document from the document's file. Receives as attribute: *attribute*. Returns: *return value*.
read_doc(PosInBytes, SizeInBytes, SizeVersion, DBName) -> 
	{ok, Fp} = file:open(DBName, [read, binary]),
	{ok, Fp2} = file:position(Fp, {bof, PosInBytes}),
	{ok, DocSize} = file:read(Fp2, SizeInBytes),
	{ok, Version} = file:read(Fp2, SizeVersion),
	{ok, Doc} = file:read(Fp2, DocSize),
	file:close(Fp),
	{ok, Version, Doc}.

%	Função que atualiza um documento no arquivo de documentos. Recebe como parâmetro: *parâmetros* . Retorna: *retorno*.
%	A function that updates a document in the document's file. Receives as attribute: *attribute*. Returns: *return value*.
update_doc(PosLastDoc, LastVersion, SizeInBytes, SizeVersion, Doc, DBName) ->
	{ok, Fp} = file:open(DBName, [write, append]),
	{ok, Pos} = file:position(Fp, cur),
	RawDocSize = byte_size(Doc),
	SizeBin = <<RawDocSize:SizeInBytes/unit:8>>, % The Size is multiplied by 8 to obtain the value in bits.
	Version = <<(LastVersion+1):SizeVersion/unit:8>>, % Version is a 2 bytes integer, refering to the times that the doc was changed. "1" means first version. The Size is multiplied by 8 to obtain the value in bits.
	PointerLastDoc = <<PosLastDoc:4/unit:8>>
	file:write(Fp, <<SizeBin/binary, Version/binary, Doc/binary, PointerLastDoc/binary>>),
	file:close(Fp),
	{ok, Pos, (LastVersion+1)}.
-module(angradbtree).
-compile(export_all).

%	Função que salva um documento no arquivo de documentos. Recebe como parâmetro: *parâmetros* . Retorna: *retorno*.
%	A function that saves a document in the document's file. Receives as attribute: *attribute*. Returns: *return value*.
save_doc(SizeInBits, Doc, DBName) -> 
	{ok, Fp} = file:open(DBName, [write, append]),
	DocBin = term_to_binary(Doc),
	SizeBin = <<byte_size(Doc):SizeBits>>.
	file:write(Fp, <<SizeBin/binary, DocBin/binary>>),
	file:close(Fp).

%	Função que lê um documento do arquivo de documentos. Recebe como parâmetro: *parâmetros* . Retorna: *retorno*.
%	A function that reads a document from the document's file. Receives as attribute: *attribute*. Returns: *return value*.
read_doc() -> true.

%	Função que atualiza um documento no arquivo de documentos. Recebe como parâmetro: *parâmetros* . Retorna: *retorno*.
%	A function that updates a document in the document's file. Receives as attribute: *attribute*. Returns: *return value*.
update_doc() -> true.

%	Função que exclui um documento no arquivo de documentos. Recebe como parâmetro: *parâmetros* . Retorna: *retorno*.
%	A function that deletes a document in document's file. Receives as attribute: *attribute*. Returns: *return value*.
delete_doc() -> true.
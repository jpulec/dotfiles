local status_ok, file_operations = pcall(require, "lsp-file-operations")
if not status_ok then
	return
end

file_operations.setup()

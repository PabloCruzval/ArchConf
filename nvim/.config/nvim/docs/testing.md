# Configuración de Testing - Neotest

## Configuración completada

Se ha configurado **Neotest** con soporte para:
- Python (unittest, pytest, django)
- JavaScript/TypeScript (Jest)
- Go
- Configuración por proyecto con archivos `.neotest.lua`
- Detección automática del intérprete de Python

## Atajos de teclado

- `<leader>ntn` - Ejecutar test más cercano
- `<leader>ntf` - Ejecutar archivo completo  
- `<leader>ntd` - Depurar test
- `<leader>nto` - Ver output
- `<leader>ntS` - Toggle resumen de tests
- `<leader>ntl` - Re-ejecutar último test

## Configuración por proyecto

### Archivo `.nvim-python`
Especifica el intérprete de Python a usar:
```bash
echo "/usr/bin/python3.12" > .nvim-python
```

### Archivo `.neotest.lua`
Configuración avanzada de tests:
```lua
-- Ejemplo básico
return {
  python = {
    runner = "unittest",
    args = { "-v" },
    test_discovery = {
      patterns = { "**/test_*.py", "**/*_test.py" },
      test_dirs = { "tests", "." },
    }
  }
}
```

## Comando de diagnóstico

`:NeotestPythonInfo` - Muestra la configuración detectada

## Uso desde Summary (`<leader>ntS`)

- `j/k` - Navegar
- `Enter` o `r` - Ejecutar test
- `d` - Depurar test
- `o` - Ver output
- `q` - Cerrar
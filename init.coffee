# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

path = require 'path'

MakePandocFile = (extention, args) ->
  [pandoc_args,cwd] =  MakePandocArgs(extention,args)
  spawnchild('pandoc',pandoc_args,cwd)

MakePandocArgs = (extention, args) ->
  editor = atom.workspace.getActiveTextEditor()
  from_path = editor.getPath()
  cwd = path.dirname(from_path)
  to_path = from_path.substr(0, from_path.lastIndexOf('.') + 1) + extention;
  fpath = [from_path]
  console.log("to path = " + path.dirname(to_path))
  pandoc_args = fpath.concat(args, ["-o"],[to_path])
  [pandoc_args, cwd]

spawnchild = (cmd,args,cwd) ->
  childProcess = require 'child_process'
  pandoc = childProcess.spawn cmd,args, {cwd}
  pandoc.stdout.on 'data', (d) -> console.log('stdout: ' + d);
  pandoc.stderr.on 'data', (d) -> console.log('stderr: ' + d);
  pandoc.on 'close', (c) -> console.log('child process exited with code ' + c);

atom.commands.add 'atom-text-editor', 'Pandoc:pandoc2Word': ->
  args = ['-s','-S']
  MakePandocFile('docx',args)

atom.commands.add 'atom-text-editor', 'Pandoc:pandoc2Tex': ->
  args = ['--latex-engine=xelatex', '-s']
  MakePandocFile('tex',args)

atom.commands.add 'atom-text-editor', 'Pandoc:pandoc2Pdf': ->
  args = ['--latex-engine=xelatex', '-s','-S']
  MakePandocFile('pdf',args)

atom.commands.add 'atom-text-editor', 'Pandoc:pandoc2HTML': ->
  args = ['--webtex','-s']
  MakePandocFile('html',args)

atom.commands.add 'atom-text-editor', 'Pandoc:pandoc2RevealJS': ->
  args = ['-t', 'revealjs','-V','theme=solarized','transistion=fade','-s']
  MakePandocFile('html',args)

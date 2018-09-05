#!/usr/bin/env waf
'''
Usage:

Configure the project giving it an optional "installation" directory:

  ./waf configure --prefix=/path/to/install

Build the main products (volume PDFs).  You can find them under build/.

  ./waf

Install the main products to the prefix.

  ./waf install

Generate and build per-chapter PDFs.  They are under build/.  You can also "install" them.

  ./waf --chapters

Generate volume tar files suitable for submission to the arXiv.  You can also "install" them.

  ./waf --arxiv

Remove build products from build/ but keep configuration.

  ./waf clean

Also remove configuration.  You will need to start over to do more.

  ./waf distclean

'''

import os

APPNAME = 'dune-tdr'
VERSION = '0.0'

# Order by "volume"
maintexs = ["guidance.tex"]

top='.'

def options(opt):
    opt.load('tex')
    opt.add_option('--debug', default=False, action='store_true',
                   help="run pdfLaTeX so that it goes into interactive mode on error.")
    opt.add_option('--chapters', default=False, action='store_true',
                   help="generate and build per-chapter PDFs")
    opt.add_option('--arxiv', default=False, action='store_true',
                   help="make a tarbal for each volume suitable for upload to arXiv")

def configure(cfg):
    cfg.load('tex')
    cfg.find_program('chapters.sh', var='CHAPTERS',
                     path_list=[os.path.join(os.path.realpath("."),"util")],
                     mandatory = True)

    cfg.env.PDFLATEXFLAGS += [
        "-file-line-error",
        "-recorder",
    ]



def nice_path(node):
    return node.path_from(node.ctx.launch_node())

# it's stuff like this, abyss:
# https://www.phy.bnl.gov/~bviren/pub/topics/waf-latex-arxiv/
# staring back at me.
import tarfile
def tarball(task):
    bld = task.generator.bld
    prefix, extra = task.generator.prefix, task.generator.extra

    globs = task.inputs[0].read() + ' ' + extra
    nodes = bld.path.ant_glob(globs)

    tfname = task.outputs[0].abspath()
    ext = os.path.splitext(tfname)[1][1:]
    with tarfile.open(tfname, 'w:'+ext, ) as tf:
        for node in nodes:
            tar_path = nice_path(node)
            if node.is_bld():
                tar_path = node.bldpath()
            tf.add(nice_path(node), prefix + tar_path)


from waflib.TaskGen import feature, after_method
@feature('tex') 
@after_method('apply_tex') 
def create_another_task(self): 
    tex_task = self.tasks[-1] 
    at = self.create_task('manifest', tex_task.outputs) 
    doc = tex_task.outputs[0]
    man = os.path.splitext(str(doc))[0] + '.manifest'
    man_node = self.bld.path.find_or_declare(man)
    at.outputs.append(man_node)
    at.tex_task = tex_task 
    # rebuild whenever the tex task is rebuilt 
    at.dep_nodes.extend(tex_task.outputs)


from waflib.Task import Task
class manifest(Task):
    def run(self):
        man_node = self.outputs[0]
        self.outputs.append(man_node)
        idx = self.tex_task.uid() 
        nodes = self.generator.bld.node_deps[idx]
        with open(man_node.abspath(), 'w') as fp:
            for node in nodes:
                fp.write(nice_path(node) + '\n')
    
def build(bld):


    prompt_level = 0
    if bld.options.debug:
        prompt_level = 1

    chaptex = bld.path.find_resource("util/chapters.tex")

    voltexs = maintexs
    for volind, voltex in enumerate(voltexs):
        volname = voltex.replace('.tex','')
        voldir = bld.path.find_dir(volname)
        volpdf = bld.path.find_or_declare(volname + '.pdf')

        voltar = bld.path.find_or_declare('%s-%s.tar.gz' % (volname, VERSION))
        volman = bld.path.find_or_declare(volname + '.manifest')

        # Task to build the volume
        bld(features='tex', prompt = prompt_level,
            source = voltex,
            target = volpdf)
        bld.install_files('${PREFIX}', [volpdf])
        
        # Tasks to build per chapter
        if bld.options.chapters:
            for chtex in voldir.ant_glob("ch*.tex"):
                chname = os.path.basename(chtex.name).replace('.tex','')
                chmaintex = bld.path.find_or_declare("%s-%s.tex" % (volname, chname))

                print chmaintex

                bld(source=[chaptex, chtex],
                    target=chmaintex,
                    rule="${CHAPTERS} ${SRC} ${TGT} '%s' '%s' %d" % (volname, chname, volind+1))

                bld(features='tex',
                    prompt = prompt_level,
                    source = os.path.basename(str(chmaintex)),
                    # name target as file name so can use --targets w/out full path
                    target = os.path.basename(str(chmaintex.change_ext('pdf','tex'))))

                bld.install_files('${PREFIX}',chmaintex.change_ext('.pdf', '.tex'))

        if bld.options.arxiv:
            bld(source=[volman, voltex],
                target=[voltar],
                prefix = '%s-%s-%s/' % (APPNAME, volname, VERSION),
                extra = voltex + ' utphys.bst dune.cls graphics/dunelogo_colorhoriz.jpg',
                rule=tarball)
            bld.install_files('${PREFIX}', [voltar])

# extract-pdf-notes  [!(https://img.shields.io/docker/cloud/automated/vsukt/extract_pdf_notes)] [!(https://img.shields.io/docker/cloud/build/vsukt/extract_pdf_notes)]
Often times we read technical/non-technical books and do lot of highlighting on it, even add some notes like meaning of some new word or out opinion about the text. I was searching for way to getting the notes out of the PDF - there are so many options
- Sumnotes.net (good service, but have to pay for extracting more notes)
- existing PDF tools like Adobe Reader (have to first configure to add highlighted text to the comments before you even start highlighting), is also good but you have to pre-configure it
- research assistants like Zotero (can't move notes out of it if you are going to store it somewhere outside) 
- and many more.. 



But they had their own limitations - and I had some specific requirement (getting the reference images along-with the text). Reading pdfs on android/linux/windows etc so definitely using different apps on each (I can use Foxit on all, but there are better options on android to make my notes easily), so needed all info stored in PDF extractable without paying huge amount to some service.


There is a question asked by stackexchage user for this same purpose. Refer to - https://stackoverflow.com/questions/21050551/extracting-text-from-higlighted-text-using-poppler-qt4-python-poppler-qt4

 
I've just update the script with additional code to extract highlighted images (with Foxit draw box around image - just keep the border thin) and made directly usable without installing poppler-qt5 on your system. So just use it whenever needed and throw away when done - without keeping any footprints (libraries/dependencies that you don't require, etc) on your system
  
  
There is already a gist available, just making it somewhat easy to use with Docker container or vagrant config, so it can be used without installing dependencies of it.


Here you have following ways to execute the script
* Build dependencies on your system major requirement is `python3-poppler-qt5`, `PyQt5` (tested on ubuntu bionic-18.04)
* Using docker image 
* Creating your own VM using Vagrantfile and then using the script

 
## Using online docker image  
To use my latest docker-image from the dockerhub. This one is easiest among the available methods.

### Requirements
* You need Docker installed and running on the system (link to install provided above)   

### Usage
* Navigate to the directory with the highlighted pdf. 
* With docker commands, (Assuming that you have a pdf Sample Book.pdf in the current directory)
    * Start the container from the image as follows
        ```
        docker run -v "${PWD}":/notes --user $(id -u):$(id -u)  vsukt/extract_pdf_notes:latest "Sample Book.pdf"
        ```
    * This will mount the current directory inside the container as /notes (which is working directory of the container)
    
    * The name of pdf will be an argument to the script which will start printing highlighted text on the command line
            - Text annotations/Typewriter/Comments
            - Highlights/Underline/Strikeout. etc

    * It will also print the name of the image file as a part of output text and will create PNG files for any Geometric annotations
        > This can be useful to extract image files from the pdf - you cna then insert these images where you'll be keeping your final notes.

        *NOTE*: Current resolution is `150p`. If you want to change it, use the local docker image method mentioned above
        
    * You can save the text output by redirecting it to another file e.g.
        ```
        docker run -v "${PWD}":/notes --user $(id -u):$(id -u) vsukt/extract_pdf_notes:latest "Sample Book.pdf" >"Sample Book.txt"
        ```
* or just grab the extract_notes.sh and execute it with PDF file name as argument.  
    ```bash
    mkdir -p ~/.local/bin
    curl -sSL https://raw.githubusercontent.com/v-sukt/extract-pdf-notes/master/extract_notes.sh -o ~/.local/bin/extract_notes && chmod a+x ~/.local/bin/extract_notes
    echo $PATH | grep ~/.local/bin > /dev/null || echo "export PATH=$HOME/.local/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
    extract_notes "Sample File.pdf"
    ```
    It'll create a local directory with filename_Notes and keep all your notes in there. If you get `bash: curl: command not found` then you'll have to install `curl` or use `wget` instead of curl.

## Using local docker image

### Requirements:
* docker installed and running (https://docs.docker.com/install/)

### Building the local image 
* clone the repo (https://www.github.com/v-sukt/extract-pdf-notes) and change to repo directory
* then execute
	```
	docker build -t extract_pdf_notes:0.6 .
	```
* once build is complete you can use the local image tagged extract_pdf_notes:0.6 

### Usage
* Navigate to the directory with the highlighted pdf
* Assuming that you've a pdf `Sample Book.pdf` in the current directory
	* Start the container from image as follows
		```
		docker run -v "${PWD}":/notes extract_notes:0.6 "Sample Book.pdf"
		```
    * This will mount the current directory inside container as /notes (which is working directory of the container)
    * The name of pdf will be argument to the script which will start printing highlighted text on commandline
        - Text annotations/Typewriter/Comments
        - Highlights/Underline/Strikeout. etc
    * It will also print name of the image file as a part of output text and will create a PNG file for any Geometric annotations
        
        This can be useful to extact image files from the pdf 
        
        NOTE: Current resolution is 150p. If you want to change it change the variable `resolution` in `extract_pdf_notes.py` file)
     
    * You can save the text output by redirecting it to another file e.g. 
        ```
        docker run -v "${PWD}":/notes extract_notes:0.6 "Sample Book.pdf" >"Sample Book.txt"
        ```


## Using local VM (Vagrant+Virtualbox)
This method uses Vagrantfile for creating a VM for you. Which will also mount current directory inside VM at /vagrant - where you can extract your notes by placing the file in it.
   
### Requirements
* Vagrant (https://www.vagrantup.com/docs/installation/)
* VirtualBox (https://www.virtualbox.org/wiki/Downloads) or any other provider support by Vagrant (https://www.vagrantup.com/docs/providers/)

### Starting the VM
* Clone the repo (https://www.github.com/v-sukt/extract-pdf-notes) and change to repo directory
* Then execute
	```
	vagrant up --provision
	```
* This will then start the VM and install dependencies 

### Usage
* Copy the highlighted pdf to the repo directory 
* Assuming that you've a pdf `Sample Book.pdf` in the current directory
	* Get inside the VM with
		```
		vagrant ssh
		```
    * The VM has mounted the current directory in at `/vagrant` - so anything that happens inside will be reflected in the repo directory

    * To execute the script use
        ```
        python3 extract_pdf_notes.py 'Sample Book.pdf'
        ``` 

    * The name of pdf will be argument to the script which will start printing highlighted text on commandline
        - Text annotations/Typewriter/Comments
        - Highlights/Underline/Strikeout. etc

    * It will also print name of the image file as a part of output text and will create a PNG file for any Geometric annotations
        
        This can be useful to extract image files from the pdf 
        
        NOTE: Current resolution is 150p. If you want to change it change the variable `resolution` in `extract_pdf_notes.py` file)
     
    * You can save the text output by redirecting it to another file e.g. 
        ```
        python3 extract_pdf_notes.py "Sample Book.pdf" >"Sample Book.txt"
        ```
    

Hope this was useful !!
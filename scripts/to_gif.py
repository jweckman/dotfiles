from pathlib import Path
from PIL import Image
from datetime import datetime
from typing import List
import shutil

def dates_from_fnames(files):
    start = 'img_'
    end = 'T'
    dates = []
    for f in files:
        fname = f.name
        date_string = fname[fname.find(start) + len(start):fname.find(end)]
        dates.append(datetime.strptime(date_string, '%Y-%m-%d'))
    return dict(zip(files, dates))

def dict_duplicates_removal(d):
    temp = []
    res = dict()
    for key, val in d.items():
        if val not in temp:
            temp.append(val)
            res[key] = val
    return res

def gif_conversion(files):
    size = 700,700
    img, *imgs = [Image.open(f) for f in sorted(files)]
    [x.thumbnail(size) for x in ([img] + imgs)]
    img.save(fp=fp_out, format='GIF', append_images=imgs,
             save_all=True, duration=200, loop=0)

def write_files_to_folder(files: List[Path], new_folder):
    [shutil.move(f, (Path(new_folder) / f.name)) for f in files]
    #delete = input('You are moving files from {files[0].stem} to {str(new_folder)}, type y to also delete old files')
    #if delete == 'y':
    #    [p.unlink for p in files]

if __name__ == '__main__':
    # filepaths
    fp_in = Path("/home/joakim/Pictures/camera/")
    fp_out = Path("image.gif")

    file_paths = [p for p in fp_in.iterdir() if p.suffix in ['.jpg', '.png']]
    fp_dates = dates_from_fnames(file_paths)
    unique_fp_dates = dict_duplicates_removal(fp_dates)
    sorted_unique_fp_dates = dict(sorted(unique_fp_dates.items(), key=lambda x: x[1]))
    gif_conversion(sorted_unique_fp_dates.keys())
    # Use this to transfer filtered files
    #write_files_to_folder(list(sorted_unique_fp_dates.keys()), '/rpi2tb/joakim/data/irrigation/camera/2021/')

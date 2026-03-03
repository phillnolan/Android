from pypdf import PdfReader
import sys
pdf_path = r"d:\64HTTT4\Android\note\Đề bài TH môn Flutter.pdf"
out_path = "pdf_extracted.txt"
reader = PdfReader(pdf_path)
with open(out_path, "w", encoding="utf-8") as f:
    for i, page in enumerate(reader.pages, start=1):
        text = page.extract_text()
        f.write(f"--- Page {i} ---\n")
        if text:
            f.write(text + "\n\n")
        else:
            f.write("[No text extracted]\n\n")
print("Extraction complete, output:", out_path)

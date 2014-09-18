module ApplicationHelper
  def lesc(text)
    LatexToPdf.escape_latex(text)
  end
  def download(q)
    @qq=3*q
  end
end

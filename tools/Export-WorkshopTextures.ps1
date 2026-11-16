$ErrorActionPreference='Stop'
if($PSVersionTable.PSEdition -eq 'Core'){
    & (Join-Path $env:WINDIR 'System32/WindowsPowerShell/v1.0/powershell.exe') -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath
    if($LASTEXITCODE -ne 0){throw 'Windows texture export failed'}
    exit 0
}
Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System; using System.IO; using System.Drawing; using System.Drawing.Imaging; using System.Drawing.Drawing2D; using System.Runtime.InteropServices;
public static class WorkshopTextureExport {
 public static void Export(string input,string output,int w,int h) {
  using(var source=Image.FromFile(input)) using(var bmp=new Bitmap(w,h,PixelFormat.Format32bppArgb)) {
   using(var g=Graphics.FromImage(bmp)) {g.CompositingMode=CompositingMode.SourceCopy;g.InterpolationMode=InterpolationMode.HighQualityBicubic;g.PixelOffsetMode=PixelOffsetMode.HighQuality;g.DrawImage(source,new Rectangle(0,0,w,h));}
   var data=bmp.LockBits(new Rectangle(0,0,w,h),ImageLockMode.ReadOnly,PixelFormat.Format32bppArgb);
   try { using(var writer=new BinaryWriter(File.Create(output))) {
    byte[] header=new byte[18];header[2]=2;header[12]=(byte)(w&255);header[13]=(byte)(w>>8);header[14]=(byte)(h&255);header[15]=(byte)(h>>8);header[16]=32;header[17]=40;writer.Write(header);
    byte[] row=new byte[w*4];for(int y=0;y<h;y++){Marshal.Copy(IntPtr.Add(data.Scan0,y*data.Stride),row,0,row.Length);writer.Write(row);}
   }}finally{bmp.UnlockBits(data);}
  }
 }
}
'@ -ReferencedAssemblies System.Drawing
$root=Split-Path -Parent $PSScriptRoot
foreach($asset in @(@('WorkshopCard',2048,1024),@('WorkshopLogoFrame',1024,1024),@('WorkshopAction',2048,512),@('WorkshopGoblin',1024,1024))){
    [WorkshopTextureExport]::Export((Join-Path $root ('docs/assets/workshop/'+$asset[0]+'.png')),(Join-Path $root ('Art/'+$asset[0]+'.tga')),$asset[1],$asset[2])
    Write-Host ($asset[0]+' RGBA32 TGA '+$asset[1]+'x'+$asset[2])
}

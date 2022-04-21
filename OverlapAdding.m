function AddResult = OverlapAdding(SampleIndex, f0, fs, FoFformant)

interval = round(fs/f0);

if SampleIndex >= length(FoFformant)-1
    endposition = length(FoFformant)-1;
else
    endposition = SampleIndex;
end

AddResult = 0;

for i = (mod(SampleIndex,interval)):interval:endposition

    AddResult = AddResult + FoFformant(i+1);
end


end
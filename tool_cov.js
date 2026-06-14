const fs=require('fs'), cp=require('child_process'), path=require('path');
const lcov=fs.readFileSync('coverage/lcov.info','utf8');
const records={}; let cur=null;
for(const raw of lcov.split('\n')){
  const line=raw.trim();
  if(line.startsWith('SF:')){cur=line.slice(3).split('\\').join('/');records[cur]={found:0,hit:0,miss:[]};}
  else if(line.startsWith('DA:')){const parts=line.slice(3).split(',');const c=+parts[1];records[cur].found++;if(c>0)records[cur].hit++;else records[cur].miss.push(+parts[0]);}
}
const allf=cp.execSync('git ls-files lib/*.dart').toString().split('\n').filter(Boolean);
const isGen=p=>/\.(g|freezed|config)\.dart$/.test(p)||p.includes('l10n/gen')||p.includes('/gen/');
const isExcl=p=>{
  if(isGen(p))return true;
  const base=path.basename(p);
  if(p.startsWith('lib/design_system/'))return true;
  if(p==='lib/environment.dart'||p==='lib/bootstrap.dart')return true;
  if(p.includes('/dependencies/'))return true;
  if(p.startsWith('lib/main_'))return true;
  if(p.includes('/navigation/')&&(base.includes('router')||base.includes('routes')||base==='navigation.dart'))return true;
  if(base==='l10n.dart')return true;
  return false;
};
let functional=allf.map(p=>p.split('\\').join('/')).filter(p=>!isExcl(p));
const readSafe=p=>{try{return fs.readFileSync(p,'utf8');}catch(e){return '';}};
const isBarrel=p=>{const t=readSafe(p);const ls=t.split('\n').map(l=>l.trim()).filter(l=>l&&!l.startsWith('//'));return ls.length>0&&ls.every(l=>l.startsWith('export '));};
const isIgnored=p=>readSafe(p).includes('coverage:ignore-file');
const barrels=functional.filter(isBarrel);
functional=functional.filter(p=>!barrels.includes(p)&&!isIgnored(p));
let miss=0;
console.log('=== FUNCTIONAL FILES NEEDING WORK ===');
for(const p of functional.sort()){
  const r=records[p];
  if(!r){console.log('  NOT-LOADED   '+p);miss++;}
  else if(r.hit<r.found){const pct=r.found?100*r.hit/r.found:100;console.log('  '+pct.toFixed(1)+'% ('+r.hit+'/'+r.found+') '+p+' miss:['+r.miss.slice(0,40).join(',')+']');miss++;}
}
console.log('\nneeding work: '+miss+'/'+functional.length+'; barrels skipped: '+barrels.length);

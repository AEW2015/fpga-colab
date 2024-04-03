------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2014, Aeroflex Gaisler
--  Copyright (C) 2015 - 2021, Cobham Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-----------------------------------------------------------------------------
-- Entity:      noelv
-- File:        noelv.vhd
-- Author:      Nils Wessman, Cobham Gaisler
-- Description: NOEL-V single processor core
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
library gaisler;
use gaisler.noelvint.all;
use gaisler.noelv.all;
use gaisler.arith.all;
library techmap;
use techmap.gencomp.all;
use techmap.netcomp.all;

entity noelvcpu is
  generic (
    hindex   : integer := 0;
    fabtech  : integer := kintex7;
    memtech  : integer := kintex7;
    mularch  : integer := 0;
    cached   : integer := 16#FFF0#;
    wbmask   : integer := 0;
    busw     : integer := 32;
    cmemconf : integer := 0;
    rfconf   : integer := 0;
    fpuconf  : integer := 0;
    tcmconf  : integer := 0;
    disas    : integer := 1;
    pbaddr   : integer := 16#90000#;
    cfg      : integer := 5;
    scantest : integer := 0
    );
  port (
    clk   : in  std_ulogic;
    rstn  : in  std_ulogic;
    ahbi  : in  ahb_mst_in_type;
    ahbo  : out ahb_mst_out_type;
    ahbsi : in  ahb_slv_in_type;
    ahbso : in  ahb_slv_out_vector;
    irqi  : in  nv_irq_in_type;
    irqo  : out nv_irq_out_type;
    dbgi  : in  nv_debug_in_type;
    dbgo  : out nv_debug_out_type;
    cnt   : out nv_counter_out_type
    );
end;

architecture hier of noelvcpu is


  signal vcc            : std_logic;
  signal gnd            : std_logic;

  type cfg_i_type is record
    single_issue  : integer;
    ext_m         : integer;
    ext_a         : integer;
    ext_c         : integer;
    ext_h         : integer;
    mode_s        : integer;
    mode_u        : integer;
    fpulen        : integer;
    pmp_no_tor    : integer;
    pmp_entries   : integer;
    pmp_g         : integer;
    perf_cnts     : integer;
    perf_evts     : integer;
    tbuf          : integer;
    trigger       : integer;
    icen          : integer;
    iways         : integer;
    iwaysize      : integer;
    ilinesize     : integer;
    dcen          : integer;
    dways         : integer;
    dwaysize      : integer;
    dlinesize     : integer;
    mmuen         : integer;
    itlbnum       : integer;
    dtlbnum       : integer;
    htlbnum       : integer;
    div_hiperf    : integer;
    div_small     : integer;
    late_branch   : integer;
    late_alu      : integer;
    bhtentries    : integer;
    bhtlength     : integer;
    predictor     : integer;
    btbentries    : integer;
    btbsets       : integer;
  end record;
  constant cfg_none : cfg_i_type := (
    single_issue  => 0,
    ext_m         => 0,
    ext_a         => 0,
    ext_c         => 0,
    ext_h         => 0,
    mode_s        => 0,
    mode_u        => 0,
    fpulen        => 0,
    pmp_no_tor    => 0,
    pmp_entries   => 0,
    pmp_g         => 0,
    perf_cnts     => 0,
    perf_evts     => 0,
    tbuf          => 0,
    trigger       => 0,
    icen          => 0,
    iways         => 4,
    iwaysize      => 4,
    ilinesize     => 8,
    dcen          => 0,
    dways         => 4,
    dwaysize      => 4,
    dlinesize     => 8,
    mmuen         => 0,
    itlbnum       => 2,
    dtlbnum       => 2,
    htlbnum       => 1,
    div_hiperf    => 0, 
    div_small     => 0, 
    late_branch   => 0,
    late_alu      => 0,
    bhtentries    => 32,
    bhtlength     => 2,
    predictor     => 0,
    btbentries    => 8,
    btbsets       => 1);

  type cfg_type is array (natural range <>) of cfg_i_type;

  constant cfg_c : cfg_type(0 to 7) := (
    -- HPP
    0 => (
      single_issue  => 0,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1, -- Should be enabled
      ext_h         => 1,
      mode_s        => 1,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      tbuf          => 4,
      trigger       => 32*0 + 16*1 + 2,
      icen          => 1,
      iways         => 4,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 4,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 1,
      itlbnum       => 8,
      dtlbnum       => 8,
      htlbnum       => 8,
      div_hiperf    => 1, 
      div_small     => 0, 
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 128,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- GPP (dual-issue)
    1 => (
      single_issue  => 0,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1, -- Should be enabled
      ext_h         => 1,
      mode_s        => 1,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      tbuf          => 4,
      trigger       => 32*0 + 16*1 + 2,
      icen          => 1,
      iways         => 4,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 4,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 1,
      itlbnum       => 8,
      dtlbnum       => 8,
      htlbnum       => 8,
      div_hiperf    => 1, 
      div_small     => 0, 
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 128,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- GPP (single-issue)
    2 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1, -- Should be enabled
      ext_h         => 1,
      mode_s        => 1,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      tbuf          => 4,
      trigger       => 32*0 + 16*1 + 2,
      icen          => 1,
      iways         => 4,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 4,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 1,
      itlbnum       => 8,
      dtlbnum       => 8,
      htlbnum       => 8,
      div_hiperf    => 1, 
      div_small     => 0, 
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 128,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- MIN (FPU)
    3 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 0,
      mode_s        => 0,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      tbuf          => 4,
      trigger       => 32*0 + 16*0 + 2,
      icen          => 1,
      iways         => 2,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 2,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 0,
      itlbnum       => 2,
      dtlbnum       => 2,
      htlbnum       => 1,
      div_hiperf    => 0, 
      div_small     => 0, 
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 64,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- MIN (no FPU)
    4 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 0,
      mode_s        => 0,
      mode_u        => 1,
      fpulen        => 0,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      tbuf          => 4,
      trigger       => 32*0 + 16*0 + 2,
      icen          => 1,
      iways         => 2,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 2,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 0,
      itlbnum       => 2,
      dtlbnum       => 2,
      htlbnum       => 1,
      div_hiperf    => 0, 
      div_small     => 0, 
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 64,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- TIN
    5 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 0,
      ext_c         => 0,
      ext_h         => 0,
      mode_s        => 0,
      mode_u        => 0,
      fpulen        => 0,
      pmp_no_tor    => 0,
      pmp_entries   => 0,
      pmp_g         => 10,
      perf_cnts     => 0,
      perf_evts     => 0,
      tbuf          => 1,
      trigger       => 32*0 + 16*0 + 0,
      icen          => 0,
      iways         => 1,
      iwaysize      => 1,
      ilinesize     => 8,
      dcen          => 0,
      dways         => 1,
      dwaysize      => 1,
      dlinesize     => 8,
      mmuen         => 0,
      itlbnum       => 2,
      dtlbnum       => 2,
      htlbnum       => 1,
      div_hiperf    => 0, 
      div_small     => 1, 
      late_branch   => 0,
      late_alu      => 0,
      bhtentries    => 32,
      bhtlength     => 2,
      predictor     => 2,
      btbentries    => 8,
      btbsets       => 2),
    others => cfg_none
    );

begin
  vcc <= '1'; gnd <= '0';

  u0 : cpucorenv -- NOEL-V Core
    generic map (
      hindex          => hindex,
      fabtech         => fabtech,
      memtech         => memtech,
      -- BHT
      bhtentries      => cfg_c(cfg).bhtentries,
      bhtlength       => cfg_c(cfg).bhtlength,
      predictor       => cfg_c(cfg).predictor,
      -- BTB
      btbentries      => cfg_c(cfg).btbentries,
      btbsets         => cfg_c(cfg).btbsets,
      -- Caches
      icen            => cfg_c(cfg).icen,
      iways           => cfg_c(cfg).iways,
      ilinesize       => cfg_c(cfg).ilinesize,
      iwaysize        => cfg_c(cfg).iwaysize,
      dcen            => cfg_c(cfg).dcen,
      dways           => cfg_c(cfg).dways,
      dlinesize       => cfg_c(cfg).dlinesize,
      dwaysize        => cfg_c(cfg).dwaysize,
      -- MMU
      mmuen           => cfg_c(cfg).mmuen,
      itlbnum         => cfg_c(cfg).itlbnum,
      dtlbnum         => cfg_c(cfg).dtlbnum,
      htlbnum         => cfg_c(cfg).htlbnum,
      tlbforepl       => 4,
      riscv_mmu       => 2,
      pmp_no_tor      => cfg_c(cfg).pmp_no_tor,
      pmp_entries     => cfg_c(cfg).pmp_entries,
      pmp_g           => cfg_c(cfg).pmp_g,
      -- Extensions
      ext_m           => cfg_c(cfg).ext_m,
      ext_a           => cfg_c(cfg).ext_a,
      ext_c           => cfg_c(cfg).ext_c,
      ext_h           => cfg_c(cfg).ext_h,
      mode_s          => cfg_c(cfg).mode_s,
      mode_u          => cfg_c(cfg).mode_u,
      fpulen          => cfg_c(cfg).fpulen,
      trigger         => cfg_c(cfg).trigger,
      -- Advanced Features
      late_branch     => cfg_c(cfg).late_branch,
      late_alu        => cfg_c(cfg).late_alu,
      -- Core
      cached          => cached,
      wbmask          => wbmask,
      busw            => busw,
      cmemconf        => cmemconf,
      rfconf          => rfconf,
      tcmconf         => tcmconf,
      tbuf            => cfg_c(cfg).tbuf,
      physaddr        => 32,
      rstaddr         => 16#00000#,
      -- Misc
      dmen            => 1,
      pbaddr          => pbaddr,
      disas           => disas,
      perf_cnts       => cfg_c(cfg).perf_cnts,
      perf_evts       => cfg_c(cfg).perf_evts,
      illegalTval0    => 0,
      no_muladd       => 0,
      single_issue    => cfg_c(cfg).single_issue,
      mularch         => mularch,
      div_hiperf      => cfg_c(cfg).div_hiperf,
      div_small       => cfg_c(cfg).div_small,
      scantest        => scantest,
      endian          => 1  -- Only Little-endian is supported
      )
    port map (
      clk             => clk,
      gclk            => clk,
      rstn            => rstn,
      ahbi            => ahbi,
      ahbo            => ahbo,
      ahbsi           => ahbsi,
      ahbso           => ahbso,
      irqi            => irqi,
      irqo            => irqo,
      dbgi            => dbgi,
      dbgo            => dbgo,
      cnt             => cnt
      );
end;

{-# LANGUAGE TypeInType, TypeOperators, GADTs, TypeFamilies, MultiParamTypeClasses,
    FlexibleInstances, UndecidableInstances, ScopedTypeVariables, FlexibleContexts, RankNTypes #-}

{-# OPTIONS_GHC -fplugin GHC.TypeLits.Normalise #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  Mezzo.Compose.Types
-- Description :  Common types
-- Copyright   :  (c) Dima Szamozvancev
-- License     :  MIT
--
-- Maintainer  :  ds709@cam.ac.uk
-- Stability   :  experimental
-- Portability :  portable
--
-- Types used by the composition library.
--
-----------------------------------------------------------------------------

module Mezzo.Compose.Types
    (
    -- * Duration type synonyms
      Whole
    , Half
    , Quarter
    , Eighth
    , Sixteenth
    , ThirtySecond
    -- * Melody
    , Melody (..)
    )
    where

import Mezzo.Model
import Mezzo.Model.Prim

import Mezzo.Compose.Builder

import Data.Kind
import GHC.TypeLits

infixl 5 :|
infixl 5 :<<<
infixl 5 :<<
infixl 5 :<
infixl 5 :^
infixl 5 :>
infixl 5 :>>
infixl 5 :<<.
infixl 5 :<.
infixl 5 :^.
infixl 5 :>.
infixl 5 :>>.
infixl 5 :~|
infixl 5 :~<<<
infixl 5 :~<<
infixl 5 :~<
infixl 5 :~^
infixl 5 :~>
infixl 5 :~>>
infixl 5 :~<<.
infixl 5 :~<.
infixl 5 :~^.
infixl 5 :~>.
infixl 5 :~>>.

-------------------------------------------------------------------------------
-- Duration type synonyms
-------------------------------------------------------------------------------

-- | Whole note duration.
type Whole = 32

-- | Half note duration.
type Half = 16

-- | Quarter note duration.
type Quarter = 8

-- | Eighth note duration.
type Eighth = 4

-- | Sixteenth note duration.
type Sixteenth = 2

-- | Thirty-second note duration.
type ThirtySecond = 1

-------------------------------------------------------------------------------
-- Musical lists
-------------------------------------------------------------------------------

-- | Single-voice melody: gives an easy way to input notes and rests of different lengths.
data Melody :: forall l. Partiture 1 l -> Nat -> Type where
    -- | Start a new melody. If the first note duration is not specified ('(:|)' is used),
    -- the default duration is a quarter.
    Melody  :: Melody (End :-- None) Quarter
    -- | Add a note with the same duration as the previous one.
    (:|)    :: (MelConstraints ms (FromRoot r d), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r d) d
    -- | Add a thirty-second note.
    (:<<<)  :: (MelConstraints ms (FromRoot r ThirtySecond), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r ThirtySecond) ThirtySecond
    -- | Add a sixteenth note.
    (:<<)   :: (MelConstraints ms (FromRoot r Sixteenth), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r Sixteenth) Sixteenth
    -- | Add an eighth note.
    (:<)    :: (MelConstraints ms (FromRoot r Eighth), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r Eighth) Eighth
    -- | Add a quarter note.
    (:^)    :: (MelConstraints ms (FromRoot r Quarter), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r Quarter) Quarter
    -- | Add a half note.
    (:>)    :: (MelConstraints ms (FromRoot r Half), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r Half) Half
    -- | Add a whole note.
    (:>>)   :: (MelConstraints ms (FromRoot r Whole), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r Whole) Whole
    -- | Add a dotted sixteenth note.
    (:<<.)  :: (MelConstraints ms (FromRoot r (Dot Sixteenth)), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r (Dot Sixteenth)) (Dot Sixteenth)
    -- | Add a dotted eighth note.
    (:<.)   :: (MelConstraints ms (FromRoot r (Dot Eighth)), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r (Dot Eighth)) (Dot Eighth)
    -- | Add a dotted quarter note.
    (:^.)   :: (MelConstraints ms (FromRoot r (Dot Quarter)), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r (Dot Quarter)) (Dot Quarter)
    -- | Add a dotted half note.
    (:>.)   :: (MelConstraints ms (FromRoot r (Dot Half)), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r (Dot Half)) (Dot Half)
    -- | Add a dotted whole note.
    (:>>.)  :: (MelConstraints ms (FromRoot r (Dot Whole)), IntRep r, Primitive d)
           => Melody ms d -> RootS r -> Melody (ms +|+ FromRoot r (Dot Whole)) (Dot Whole)
    -- | Add a rest with the same duration as the previous one.
    (:~|)   :: (MelConstraints ms (FromSilence d), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence d) d
    -- | Add a thirty-second rest.
    (:~<<<) :: (MelConstraints ms (FromSilence ThirtySecond), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence ThirtySecond) ThirtySecond
    -- | Add a sixteenth rest.
    (:~<<)  :: (MelConstraints ms (FromSilence Sixteenth), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence Sixteenth) Sixteenth
    -- | Add an eighth rest.
    (:~<)   :: (MelConstraints ms (FromSilence Eighth), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence Eighth) Eighth
    -- | Add a quarter rest.
    (:~^)   :: (MelConstraints ms (FromSilence Quarter), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence Quarter) Quarter
    -- | Add a half rest.
    (:~>)   :: (MelConstraints ms (FromSilence Half), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence Half) Half
    -- | Add a whole rest.
    (:~>>)  :: (MelConstraints ms (FromSilence Whole), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence Whole) Whole
    -- | Add a dotted sixteenth rest.
    (:~<<.) :: (MelConstraints ms (FromSilence (Dot Sixteenth)), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence (Dot Sixteenth)) (Dot Sixteenth)
    -- | Add a dotted eighth rest.
    (:~<.)  :: (MelConstraints ms (FromSilence (Dot Eighth)), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence (Dot Eighth)) (Dot Eighth)
    -- | Add a dotted quarter rest.
    (:~^.)  :: (MelConstraints ms (FromSilence (Dot Quarter)), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence (Dot Quarter)) (Dot Quarter)
    -- | Add a dotted half rest.
    (:~>.)  :: (MelConstraints ms (FromSilence (Dot Half)), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence (Dot Half)) (Dot Half)
    -- | Add a dotted whole rest.
    (:~>>.) :: (MelConstraints ms (FromSilence (Dot Whole)), Primitive d)
           => Melody ms d -> RestS -> Melody (ms +|+ FromSilence (Dot Whole)) (Dot Whole)

-- raiseByOct :: Melody m d -> Melody (RaiseAllByOct m) d

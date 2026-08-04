(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	image0 - mode
	GroundStation1 - direction
	Star3 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation16 - direction
	Star18 - direction
	Star29 - direction
	Star31 - direction
	GroundStation32 - direction
	Star33 - direction
	GroundStation35 - direction
	GroundStation37 - direction
	GroundStation38 - direction
	Star43 - direction
	GroundStation45 - direction
	Star46 - direction
	Star47 - direction
	Star0 - direction
	GroundStation27 - direction
	GroundStation34 - direction
	Star22 - direction
	GroundStation40 - direction
	GroundStation2 - direction
	Star19 - direction
	GroundStation28 - direction
	GroundStation8 - direction
	Star15 - direction
	Star23 - direction
	GroundStation5 - direction
	GroundStation30 - direction
	GroundStation44 - direction
	GroundStation4 - direction
	Star21 - direction
	Star14 - direction
	GroundStation25 - direction
	GroundStation24 - direction
	Star6 - direction
	GroundStation7 - direction
	Star42 - direction
	Star41 - direction
	Star26 - direction
	GroundStation39 - direction
	Star9 - direction
	Star36 - direction
	GroundStation48 - direction
	GroundStation20 - direction
	GroundStation17 - direction
	Planet49 - direction
	Planet50 - direction
	Star51 - direction
	Phenomenon52 - direction
	Planet53 - direction
	Planet54 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star23)
	(calibration_target instrument0 Star15)
	(calibration_target instrument0 GroundStation48)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 Star42)
	(calibration_target instrument0 GroundStation28)
	(calibration_target instrument0 Star41)
	(calibration_target instrument0 Star19)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation40)
	(calibration_target instrument0 Star22)
	(calibration_target instrument0 Star36)
	(calibration_target instrument0 GroundStation34)
	(calibration_target instrument0 GroundStation27)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 image0)
	(calibration_target instrument1 Star41)
	(calibration_target instrument1 GroundStation44)
	(calibration_target instrument1 Star36)
	(calibration_target instrument1 GroundStation5)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation32)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation44)
	(calibration_target instrument2 GroundStation30)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet49)
	(supports instrument3 image0)
	(calibration_target instrument3 Star41)
	(calibration_target instrument3 GroundStation24)
	(calibration_target instrument3 GroundStation25)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 Star14)
	(calibration_target instrument3 Star21)
	(calibration_target instrument3 GroundStation4)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation5)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation17)
	(calibration_target instrument4 GroundStation20)
	(calibration_target instrument4 GroundStation48)
	(calibration_target instrument4 Star36)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation39)
	(calibration_target instrument4 Star26)
	(calibration_target instrument4 Star41)
	(calibration_target instrument4 Star42)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 Star6)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star19)
)
(:goal (and
	(pointing satellite1 GroundStation20)
	(pointing satellite4 GroundStation20)
	(have_image Planet49 image0)
	(have_image Planet50 image0)
	(have_image Star51 image0)
	(have_image Phenomenon52 image0)
	(have_image Planet53 image0)
	(have_image Planet54 image0)
))

)

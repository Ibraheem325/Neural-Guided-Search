(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	infrared0 - mode
	spectrograph3 - mode
	image1 - mode
	image2 - mode
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation21 - direction
	Star25 - direction
	GroundStation26 - direction
	GroundStation27 - direction
	GroundStation29 - direction
	GroundStation22 - direction
	Star0 - direction
	GroundStation16 - direction
	Star15 - direction
	Star14 - direction
	Star23 - direction
	GroundStation17 - direction
	GroundStation28 - direction
	GroundStation19 - direction
	GroundStation24 - direction
	Star5 - direction
	GroundStation20 - direction
	GroundStation2 - direction
	Star18 - direction
	Star9 - direction
	Planet30 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 Star15)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation16)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation28)
	(calibration_target instrument0 GroundStation19)
	(calibration_target instrument0 GroundStation17)
	(calibration_target instrument0 Star23)
	(calibration_target instrument0 GroundStation22)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star25)
	(supports instrument1 spectrograph3)
	(supports instrument1 infrared0)
	(supports instrument1 image1)
	(calibration_target instrument1 GroundStation19)
	(calibration_target instrument1 GroundStation28)
	(calibration_target instrument1 GroundStation17)
	(calibration_target instrument1 Star23)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation16)
	(supports instrument2 image2)
	(supports instrument2 infrared0)
	(supports instrument2 spectrograph3)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star18)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation20)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation24)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation17)
)
(:goal (and
	(pointing satellite1 GroundStation7)
	(pointing satellite2 Star5)
	(have_image Planet30 image1)
))

)

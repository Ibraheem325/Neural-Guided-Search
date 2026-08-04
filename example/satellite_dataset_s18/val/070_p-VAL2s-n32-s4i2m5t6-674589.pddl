(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	image0 - mode
	thermograph2 - mode
	thermograph1 - mode
	spectrograph4 - mode
	image3 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation2 - direction
	GroundStation5 - direction
	Phenomenon6 - direction
	Star7 - direction
	Phenomenon8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Star14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet12)
	(supports instrument1 thermograph2)
	(supports instrument1 thermograph1)
	(supports instrument1 image3)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation5)
	(supports instrument3 image0)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star14)
	(supports instrument4 thermograph2)
	(supports instrument4 spectrograph4)
	(calibration_target instrument4 GroundStation5)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation5)
)
(:goal (and
	(pointing satellite0 Planet12)
	(pointing satellite1 GroundStation4)
	(pointing satellite2 GroundStation2)
	(have_image Phenomenon6 thermograph2)
	(have_image Star7 image3)
	(have_image Phenomenon8 thermograph1)
	(have_image Star9 image0)
	(have_image Star10 image0)
	(have_image Star11 spectrograph4)
	(have_image Planet12 thermograph1)
	(have_image Phenomenon13 spectrograph4)
	(have_image Star14 image3)
	(have_image Star15 thermograph1)
	(have_image Phenomenon16 image3)
	(have_image Phenomenon17 image0)
))

)
